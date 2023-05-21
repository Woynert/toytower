extends Control
class_name UIPauseMenu

signal sig_close

func _ready():
	
	%btnResume.connect("pressed", on_resume)
	%btnLeave.connect("pressed", on_leave)
	%btnYes.connect("pressed", on_yes)
	%btnReturn.connect("pressed", on_return)
	togglePauseMenu(false)

func reset():
	%escapeMenu.visible = true
	%confirmationDialog.visible = false

func togglePauseMenu(toggle: bool):
	reset()
	visible = toggle
	
	if toggle:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func on_resume():
	print("asdas")
	sig_close.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func on_leave():
	%escapeMenu.visible = false
	%confirmationDialog.visible = false
	
func on_yes():
	get_tree().change_scene_to_file("res://scenes/levels/mainStage.tscn")

func on_return():
	reset()
