extends VBoxContainer

signal sig_return

func _ready():
	%btnReturn.connect("button_up", btn_return)

func btn_return():
	sig_return.emit()


