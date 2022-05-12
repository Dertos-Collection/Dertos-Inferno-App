//
package view

import (
	"gioui.org/app"
	"gioui.org/io/system"
	"gioui.org/layout"
	"gioui.org/op"
	"gioui.org/widget/material"
)

type UI struct {
	W  *app.Window
	Th *material.Theme
}

func (ui *UI) Run() error {
	var ops op.Ops
	for e := range ui.W.Events() {
		switch e := e.(type) {
		case system.FrameEvent:
			gtx := layout.NewContext(&ops, e)
			// ops.Reset()
			ui.Layout(gtx)

			e.Frame(gtx.Ops)
		case system.DestroyEvent:
			return e.Err
		}
	}
	return nil
}
func (ui UI) Layout(gtx layout.Context) layout.Dimensions {
	// TODO: implement
	return layout.Flex{}.Layout(gtx,
		layout.Rigid(func(gtx layout.Context) layout.Dimensions {
			title := material.H1(ui.Th, "Kalispera")
			return title.Layout(gtx)
		}),
	)
}
