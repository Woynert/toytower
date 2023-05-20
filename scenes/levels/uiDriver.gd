extends Control

enum Menu {
	MAIN,
	SCORES
}

var currMenu: Menu = Menu.MAIN

func _ready():
	%uiMainMenu.connect("sig_play", play)
	%uiMainMenu.connect("sig_score", goToScores)
	%uiMainMenu.connect("sig_quit", quit)
	
	%uiScores.connect("sig_return", goToMain)
	
	showCurrentMenu()

func showCurrentMenu():
	%uiMainMenu.visible = false
	%uiScores.visible = false
	
	match currMenu:
		Menu.MAIN:
			%uiMainMenu.visible = true
			
		Menu.SCORES:
			%uiScores.visible = true

func play():
	print("play")
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")

func goToScores():
	currMenu = Menu.SCORES
	showCurrentMenu()
	
func goToMain():
	currMenu = Menu.MAIN
	showCurrentMenu()

func quit():
	print("quit")
	get_tree().quit()
	
