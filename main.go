package main

import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/widget"
)

func main() {
	a := app.New()
	w := a.NewWindow("Dertos' Inferno")
	w.Resize(fyne.NewSize(9*30, 16*30))
	w.SetContent(widget.NewLabel("Είμαι ο Ντέρτος και θα σε φάω"))
	w.ShowAndRun()
}
