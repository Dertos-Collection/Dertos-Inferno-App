package main

import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"
)

type State int

const (
	Menu State = iota
	Settings
	Pause
	Play
)

type ui struct {
	state State
	self  *fyne.Container
}

func (u *ui) changeState(state State) {
	u.state = state
	u.self.Refresh()
}

func (u *ui) load() fyne.CanvasObject {
	// TODO: Implement
	title := container.NewCenter(
		widget.NewLabel("Dertos' Inferno"),
	)

	u.self = container.NewBorder(
		title, nil, nil, nil,
	)
	return u.self
}

func main() {
	a := app.New()
	// a := app.NewWithID("com.dertosCollection.inferno")
	// a.SetIcon()
	// a.Settings().SetTheme()
	w := a.NewWindow("Dertos' Inferno")

	infernoUi := &ui{}
	w.SetContent(infernoUi.load())
	w.Resize(fyne.NewSize(9*30, 16*30))
	w.ShowAndRun()
}
