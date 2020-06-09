package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"time"
)

func readCameraFile(filePath string) (map[string]string, error) {
	file, err := ioutil.ReadFile(filePath)
	if err != nil {
		return nil, err
	}
	var cameras map[string]string
	err = json.Unmarshal([]byte(file), &cameras)
	if err != nil {
		return nil, err
	}
	return cameras, nil

}

func getImage(camera, filePrefix string) error {
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
	f, err := os.Create(fmt.Sprintf(filePrefix+"%s", camera))
	if err != nil {
		return err
	}
	defer f.Close()
	f.Write(body)
	return nil
}

func main() {
	defer fmt.Println("Exiting")
	filePrefix := flag.String("prefix", "/root/data/", "Prefix or file directory for data files to be written to. Defaults to /root/data/.")
	pollWait := flag.Int("poll", 1, "Time in seconds to wait before each poll. Defaults to 1 second.")
	camerasFile := flag.String("file", "", "cameras.json file to pass in. If used, will ignore the manually passed in flags")
	limit := flag.Int("limit", -1, "How many cameras to watch simultanously. Defaults to -1, which is everything passed in.")
	flag.Parse()
	var cameras []string
	if len(*camerasFile) != 0 {
		fmt.Println("Attempting to read cameras from file: ", *camerasFile)
		c, err := readCameraFile(*camerasFile)
		if err != nil {
			panic(err)
		}
		for k := range c {
			cameras = append(cameras, k)
		}
		fmt.Printf("Found %d cameras\n", len(cameras))
	} else {
		cameras = flag.Args()
	}
	if *limit != -1 {
		cameras = cameras[:*limit]

	}
	fmt.Printf("Parsing cameras: ")
	fmt.Println(cameras)

	for _, camera := range cameras {
		go func(camera, filePrefix string, pollWait int) {
			fmt.Printf("Watching camera %s, polling at %d second, writing to file %s%s\n", camera, pollWait, filePrefix, camera)
			duration := time.Duration(pollWait) * time.Second
			for _ = range time.Tick(duration) {
				err := getImage(camera, filePrefix)
				if err != nil {
					fmt.Println(err)
				}
			}
		}(camera, *filePrefix, *pollWait)
	}
	// block forever
	c := make(chan struct{})
	<-c
}
