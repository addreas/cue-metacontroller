package main

import (
	"context"
	"embed"
	"encoding/json"
	"flag"
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
	dir = flag.String("dir", ".", "Directory of cue files")

	//go:embed cue.mod/gen/**/*
	cueModOverlay embed.FS
)

func fillOvl(p string, ovl map[string]load.Source) error {
	items, err := cueModOverlay.ReadDir(p)
	if err != nil {
		return err
	}
	for _, file := range items {
		pp := path.Join(p, file.Name())
		if file.IsDir() {
			fillOvl(pp, ovl)
		} else {
			content, err := cueModOverlay.ReadFile(pp)
			if err != nil {
				return err
			}
			ovl[pp] = load.FromBytes(content)
		}
	}
	return nil
}

func main() {
	flag.Parse()

	ovl := map[string]load.Source{}
	fillOvl(".", ovl)

	cfg := &load.Config{
		Dir:     *dir,
		Package: "*",

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

	if len(instances) > 1 {
		log.Println("multiple instances found, this is unexpected")
	}

	log.Printf("loaded controller definition: %#v", instances)

	controllerDefinition := instances[0]

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {

		if r.Method != http.MethodPost {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}

		var data interface{}
		err := json.NewDecoder(r.Body).Decode(&data)
		if err != nil {
			http.Error(w, "Can't read body", http.StatusInternalServerError)
			return
		}

		splitPath := strings.Split(strings.TrimPrefix(r.URL.Path, "/"), "/")
		selectorParts := []cue.Selector{}
		for _, part := range splitPath {
			if part == "hooks" {
				selectorParts = append(selectorParts, cue.Def(part))
			} else {
				selectorParts = append(selectorParts, cue.Str(part))
			}
		}

		val := controllerDefinition.FillPath(cue.MakePath(append(selectorParts, cue.Str("request"))...), data).Value()

		log.Printf("%#v", val)

		result, err := val.LookupPath(cue.MakePath(append(selectorParts, cue.Str("response"))...)).MarshalJSON()
		if err != nil {
			log.Printf("/%s request: %v", r.URL.Path, data)
			log.Printf("/%s error: %s", r.URL.Path, err)
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.Write(result)
	})

	server := &http.Server{Addr: ":8080"}
	go func() {
		log.Fatal(server.ListenAndServe())
	}()

	// Shutdown on SIGTERM.
	sigchan := make(chan os.Signal, 2)
	signal.Notify(sigchan, os.Interrupt, syscall.SIGTERM)
	sig := <-sigchan
	log.Printf("Received %v signal. Shutting down...", sig)
	server.Shutdown(context.Background())
}
