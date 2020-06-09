package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"time"
)

func getImage(camera string) error {
	// http://207.251.86.238/261
	// where 261 is the camera name
	// all files are written in jpeg
	location := fmt.Sprintf("http://207.251.86.238/%s", camera)
	resp, err := http.Get(location)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return err
	}
	f, err := os.Create(fmt.Sprintf("./data/%s", camera))
	if err != nil {
		return err
	}
	defer f.Close()
	f.Write(body)
	return nil
}

func main() {
	camera := "261"
	for _ = range time.Tick(1 * time.Second) {
		getImage(camera)
	}

}
