package capture

import (
	"fmt"
	"os"

	"github.com/lazywei/go-opencv/opencv"
)

// get first available camera device
func GetWebcam() *opencv.Capture {
	camera := opencv.NewCameraCapture(0)
	if camera == nil {
		panic("ERROR: can not open camera")
	}
	return camera
}

// show video from webcam
func ShowVideo(camera *opencv.Capture) error {
	win := opencv.NewWindow("Go-OpenCV Camera")
	defer win.Destroy()

	for {
		if camera.GrabFrame() {
			img := camera.RetrieveFrame(1)
			win.ShowImage(img)
		} else {
			fmt.Println("ERROR: Can't read frames from Camera.")
			return nil //error
		}

		if key := opencv.WaitKey(10); key == 27 {
			os.Exit(0)
		}
	}
	opencv.WaitKey(0)
	return nil
}

// show current image object passed via opencv in passed opencv window
func ShowImage(img *opencv.IplImage, win *opencv.Window) error {

	if img == nil {
		fmt.Println("ERROR: No Image.")
		return nil //error
	}

	win.ShowImage(img)
	return nil
}

func QuickPic(camera *opencv.Capture, pic string) {
	for {
		if camera.GrabFrame() {
			img := camera.RetrieveFrame(1)
			opencv.SaveImage(pic, img, 0644)
			return
		}
	}
}
