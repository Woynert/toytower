extends VBoxContainer

signal sig_play
signal sig_score
signal sig_quit

func _ready():
	%btnPlay.connect("pressed", btn_play)
	%btnScore.connect("pressed", btn_score)
	%btnQuit.connect("pressed", btn_quit)

func btn_play():
	sig_play.emit()
	
func btn_score():
	sig_score.emit()
	
func btn_quit():
	sig_quit.emit()


