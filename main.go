package main

import (
	"log"
	"os"

	"gioui.org/app"
	"gioui.org/font/gofont"
	"gioui.org/unit"
	"gioui.org/widget/material"
	"github.com/Dertos-Collection/Dertos-Inferno-App/view"
)

func main() {
	ui := view.UI{
		W: app.NewWindow(
			app.Title("Dertos' Inferno"),
			app.Size(unit.Dp(9*40), unit.Dp(16*40)),
		),
		Th: material.NewTheme(gofont.Collection()),
	}
	go func() {
		if err := ui.Run(); err != nil {
			log.Println(err)
			os.Exit(1)
		}
		os.Exit(0)
	}()
	app.Main()
}
