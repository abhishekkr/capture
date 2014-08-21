package main

import (
	capture "github.com/abhishekkr/capture/webcam"
)

func main() {
	camera := capture.GetWebcam()
	defer camera.Release()
	capture.QuickPic(camera, "/tmp/anyimage.jpg")
	capture.ShowVideo(camera)
}
