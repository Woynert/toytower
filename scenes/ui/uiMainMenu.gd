extends VBoxContainer

signal sig_play
signal sig_score
signal sig_quit

func _ready():
	%btnPlay.connect("button_up", btn_play)
	%btnScore.connect("button_up", btn_score)
	%btnQuit.connect("button_up", btn_quit)

func btn_play():
	sig_play.emit()
	
func btn_score():
	sig_score.emit()
	
func btn_quit():
	sig_quit.emit()


