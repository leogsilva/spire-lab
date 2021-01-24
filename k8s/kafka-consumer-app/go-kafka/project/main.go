package main

import (
	"fmt"
	"html/template"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/mux"
	kafka "github.com/segmentio/kafka-go"
)

func (r *ExampleRouter) producerHandler(kafkaWriter *kafka.Writer) func(http.ResponseWriter, *http.Request) {
	return http.HandlerFunc(func(wrt http.ResponseWriter, req *http.Request) {
		body, err := ioutil.ReadAll(req.Body)
		if err != nil {
			log.Fatalln(err)
		}
		msg := kafka.Message{
			Key:   []byte(fmt.Sprintf("address-%s", req.RemoteAddr)),
			Value: body,
		}
		err = kafkaWriter.WriteMessages(req.Context(), msg)

		if err != nil {
			wrt.Write([]byte(err.Error()))
			log.Fatalln(err)
		}
	})
}

func getKafkaWriter(kafkaURL, topic string) *kafka.Writer {
	return &kafka.Writer{
		Addr:     kafka.TCP(kafkaURL),
		Topic:    topic,
		Balancer: &kafka.LeastBytes{},
	}
}

func calcUpdateDuration() time.Duration {
	if StartTime.IsZero() {
		return 0
	}
	return time.Since(StartTime)
}

type ExampleRouter struct {
	*mux.Router
	tmpl           *template.Template
	updateDuration time.Duration
}

func NewExampleRouter(kafkaWriter *kafka.Writer) (*ExampleRouter, error) {
	r := mux.NewRouter()

	tmpl, err := template.ParseGlob("./web/templates/*.tmpl")
	if err != nil {
		return nil, err
	}

	updateDuration := calcUpdateDuration()
	router := &ExampleRouter{
		Router:         r,
		tmpl:           tmpl,
		updateDuration: updateDuration,
	}

	fs := http.FileServer(http.Dir("./web"))
	r.HandleFunc("/", router.index)
	r.PathPrefix("/").Handler(fs)
	r.HandleFunc("/producer", router.producerHandler(kafkaWriter))

	return router, nil
}

func (r *ExampleRouter) updateTimeDisplay() string {
	if r.updateDuration != 0 {
		return r.updateDuration.Truncate(100 * time.Millisecond).String()
	}
	return "N/A"
}

func (r *ExampleRouter) index(w http.ResponseWriter, req *http.Request) {
	err := r.tmpl.ExecuteTemplate(w, "index.tmpl", map[string]string{
		"Duration": r.updateTimeDisplay(),
	})
	if err != nil {
		log.Printf("index: %v", err)
	}
}

func main() {
	// get kafka writer using environment variables.
	kafkaURL := os.Getenv("kafkaURL")
	topic := os.Getenv("topic")
	kafkaWriter := getKafkaWriter(kafkaURL, topic)

	defer kafkaWriter.Close()

	router, err := NewExampleRouter(kafkaWriter)
	if err != nil {
		log.Fatalf("Router creation failed: %v", err)
	}
	http.Handle("/", router)

	log.Println("Serving on port 80")
	log.Printf("Deploy time: %s\n", router.updateTimeDisplay())
	err = http.ListenAndServe(":80", nil)
	if err != nil {
		log.Fatalf("Server exited with: %v", err)
	}
}
