class_name GeneralRepo
extends Node

const ColourRepo = {
	"Healthy" = {
		"default" = "#007300",
		"deselected" = "#007300",
		"hover" = "#00b300",
		"selected" = "#bfffb9"
	},
	"Compromised" = {
		"default" = "#af2300",
		"deselected" = "#af2300",
		"hover" = "#fc3700",
		"selected" = "#ffbdae"
	}
}

const Prompts = {
	"Welcome!" =
		"Hi player!\n
		Here's what you need to know to get started.\n
		TOP MENU:
		This identifies what organisation you're playing as.
		It helps you keep track of funds and the current date.
		It also keeps track of threat actors activity.\n
		TAB BOX:
		Overview: A preview of your statistics.
		Controls: Change game options such as speed of time.
		Objectives: Keep track of your progress to winning.
		Threat Intel: Research threat actors to plan your strategy.
		Threat Feed: Alerts you of important threat activity.\n
		LOCATIONS:
		These are you company offices. Hover your mouse for a quick preview.
		Or click on them so you can implement security controls.\n\n
		GOOD LUCK!"
}
