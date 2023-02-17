package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"
)

var (
	dir = flag.String("dir", ".", "Directory of cue files")
)

func main() {
	flag.Parse()

	cfg := &load.Config{
		Dir:     *dir,
		Package: "*",

		// TODO: go:embed definitions for metacontroller, metav1, corev1 and perhaps some more defaults?
		// Overlay: map[string]load.Source,
	}

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

		hookName := strings.TrimPrefix(r.URL.Path, "/")
		reqPath := cue.ParsePath(fmt.Sprintf(`hook."%s".request`, hookName))
		resPath := cue.ParsePath(fmt.Sprintf(`hook."%s".response`, hookName))

		ix := load.Instances([]string{}, cfg)

		if ix[0].Err != nil {
			log.Fatalf("failed to build instances: %v", ix[0].Err)
		}
		inst := ix[0]
		val := cuecontext.New().BuildInstance(inst)
		val = val.FillPath(reqPath, data)
		// TODO: val.Validate() here?

		result, err := val.Eval().LookupPath(resPath).MarshalJSON()
		if err != nil {
			log.Printf("/%s request: %v", hookName, data)
			log.Printf("/%s error: %s", hookName, err)
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
