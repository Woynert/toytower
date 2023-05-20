extends Node3D


func _ready():
	
	GlobalState.reset_game()
	_on_game_state_change()
	GlobalState.connect("sig_game_state_changed", _on_game_state_change)
	
	
func _on_game_state_change():
	
	match GlobalState.game_state:
		
		GlobalState.GAME_STATE.PLAYING:
			$ui/uiLooseWinWin.visible = false
			$ui/uiLooseWinLoose.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
		GlobalState.GAME_STATE.WON:
			$ui/uiLooseWinWin.visible = true
			$ui/uiLooseWinLoose.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
		GlobalState.GAME_STATE.LOST:
			$ui/uiLooseWinWin.visible = false
			$ui/uiLooseWinLoose.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
