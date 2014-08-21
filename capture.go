package main

import (
	capture "github.com/abhishekkr/capture/webcam"
)

func main() {
	camera := capture.GetWebcam()
	defer camera.Release()
	capture.ShowVideo(camera)
}
