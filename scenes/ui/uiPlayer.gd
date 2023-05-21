extends Control
class_name UIPlayer

signal sig_on_turrent_select(index: int)

func _ready():
	toggleTurrentSelect(false)

func _physics_process(delta):
	
	# update display values
	
	%lblWave.text = str(GlobalState.round)
	%lblEnemiesLeft.text = "%d/%d" % [GlobalState.killedEnemies, GlobalState.enemiesToSpawn]
	%progressCristalHealth.value = floor((float(GlobalState.cristalHealth) / GlobalState.cristalMaxHealth) * 100)
	
	# DELETEME: input()

func toggleTurrentSelect(toggle: bool):
	%turrentSelection.visible = toggle
	
func input():
	
	if Input.is_action_just_pressed("gm_pick1"):
		sig_on_turrent_select.emit(1)
	if Input.is_action_just_pressed("gm_pick2"):
		sig_on_turrent_select.emit(2)
	if Input.is_action_just_pressed("gm_pick3"):
		sig_on_turrent_select.emit(3)
	
	
	

