package main

import (
	"context"
	"embed"
	"flag"
	"io"
	"log"
	"net/http"
	"os"
	"os/signal"
	"path"
	"strings"
	"syscall"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/errors"
	"cuelang.org/go/cue/load"
)

var (
	dir                    = flag.String("dir", ".", "Directory of cue files")
	printController        = flag.Bool("print-controller", false, "Print the controller definition on startup")
	printRequest           = flag.Bool("print-request", false, "Print received request merged is into controller definition")
	printResponse          = flag.Bool("print-response", false, "Print response after request is merged into controller definition")
	printEvaluatedResponse = flag.Bool("print-evaluated-response", false, "Print evaluated response after request is merged into controller definition")

	//go:embed cue.mod/gen/**/*
	cueModOverlay embed.FS
)

func fillOvl(p string, cwd string, ovl map[string]load.Source) error {
	items, err := cueModOverlay.ReadDir(p)
	if err != nil {
		return err
	}
	for _, file := range items {
		pp := path.Join(p, file.Name())
		if file.IsDir() {
			fillOvl(pp, cwd, ovl)
		} else {
			content, err := cueModOverlay.ReadFile(pp)
			if err != nil {
				return err
			}
			ovl[path.Join(cwd, pp)] = load.FromBytes(content)
		}
	}
	return nil
}

func main() {
	flag.Parse()

	ovl := map[string]load.Source{}
	var moduleRoot string
	if !path.IsAbs(*dir) {
		cwd, err := os.Getwd()
		if err != nil {
			log.Fatalf("failled to get cwd: %s", err)
		}
		moduleRoot = cwd
	} else {
		moduleRoot = *dir
	}
	fillOvl(".", moduleRoot, ovl)
	// log.Fatalln()

	cfg := &load.Config{
		Dir:     *dir,
		Overlay: ovl,
	}

	ix := load.Instances([]string{}, cfg)

	if ix[0].Err != nil {
		log.Fatalf("failed to load instance: %v", ix[0].Err)
	}
	instances, err := cuecontext.New().BuildInstances(ix)
	if err != nil {
		if cueErr, ok := err.(errors.Error); ok {
			log.Fatalf("failed to build instances: %s", errors.Details(cueErr, nil))
		} else {
			log.Fatalf("failed to build instances: %v", err)
		}
	}

	if len(instances) != 1 {
		log.Println("not sure where the first empty instance comes from, but the second one is the only one that should exist")
	}

	controllerDefinition := instances[0]
	if *printController {
		log.Printf("loaded controller definition: %#v", controllerDefinition)
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {

		if r.Method != http.MethodPost {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}

		data, err := io.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "Can't read body", http.StatusInternalServerError)
			return
		}
		cueData := controllerDefinition.Context().CompileBytes(data)

		if cueData.Validate() != nil {
			http.Error(w, "Can't validate body: "+errors.Details(cueData.Err(), nil), http.StatusInternalServerError)
			return
		}

		splitPath := strings.Split(strings.TrimPrefix(r.URL.Path, "/"), "/")
		selectorParts := []cue.Selector{}
		for _, part := range splitPath {
			if part[0] == '#' || part[0] == ':' { // Either have to use %23 for # to not end path/query part of url or use : as a marker instead... wat do
				selectorParts = append(selectorParts, cue.Def(part[1:]))
			} else {
				selectorParts = append(selectorParts, cue.Str(part))
			}
		}

		// log.Printf("%#v", controllerDefinition)
		val := controllerDefinition.FillPath(cue.MakePath(append(selectorParts, cue.Str("request"))...), cueData).Eval()
		err = val.Validate(cue.Concrete(true))
		if err != nil {
			details := errors.Details(err, nil)
			log.Println("error details:\n", details)
			http.Error(w, details, http.StatusInternalServerError)
			return
		}

		if *printRequest {
			log.Printf("request: %#v", val.LookupPath(cue.MakePath(append(selectorParts, cue.Str("request"))...)))
		}
		if *printResponse {
			log.Printf("response: %#v", val.LookupPath(cue.MakePath(append(selectorParts, cue.Str("response"))...)))
		}
		if *printEvaluatedResponse {
			log.Printf("evaluated response: %#v", val.LookupPath(cue.MakePath(append(selectorParts, cue.Str("response"))...)).Eval())
		}

		result, err := val.LookupPath(cue.MakePath(append(selectorParts, cue.Str("response"))...)).MarshalJSON()
		if err != nil {
			// Should be possible to catch
			log.Printf("%s error: %s", r.URL.Path, err)
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.Write(result)
	})

	server := &http.Server{Addr: ":8080"}
	go func() { log.Fatal(server.ListenAndServe()) }()
	log.Println("Listening on localhost:8080...")

	// Shutdown on SIGTERM.
	sigchan := make(chan os.Signal, 2)
	signal.Notify(sigchan, os.Interrupt, syscall.SIGTERM)
	sig := <-sigchan
	log.Printf("Received %v signal. Shutting down...", sig)
	server.Shutdown(context.Background())
}
