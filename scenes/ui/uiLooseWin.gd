extends Control
class_name UILooseWin

@export var win: bool = true

func _ready():
	
	%btnReturn.connect("pressed", on_return)
	%btnRetry.connect("pressed", on_retry)
	
	if win:
		%lblTitle.text = "You win"
		%lblInfo.text = "You have successfully defended your cristal"
		%btnRetry.visible = false
	else:
		%lblTitle.text = "You loose"
		%lblInfo.text = "The robots have destroyed your cristal. Good luck next time"

func on_return():
	GlobalAudio.play_sound("beep2")
	get_tree().change_scene_to_file("res://scenes/levels/mainStage.tscn")
	
func on_retry():
	GlobalAudio.play_sound("beep2")
	get_tree().reload_current_scene()
