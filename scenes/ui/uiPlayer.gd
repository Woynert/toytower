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
	%lblMoney.text = "%d $" % GlobalState.money
	
	# DELETEME: input()

func toggleTurrentSelect(toggle: bool):
	
	%turrentSelection.visible = toggle
	%lblPrice1.text = "%d $" % DATA.turrent_prices[0]
	%lblPrice2.text = "%d $" % DATA.turrent_prices[1]
	%lblPrice3.text = "%d $" % DATA.turrent_prices[2]
	
func input():
	
	if Input.is_action_just_pressed("gm_pick1"):
		sig_on_turrent_select.emit(1)
	if Input.is_action_just_pressed("gm_pick2"):
		sig_on_turrent_select.emit(2)
	if Input.is_action_just_pressed("gm_pick3"):
		sig_on_turrent_select.emit(3)
	
	
	

