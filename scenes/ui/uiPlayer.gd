extends Control

func _physics_process(delta):
	
	# update display values
	
	%lblWave.text = str(GlobalState.round)
	%progressCristalHealth.value = floor((float(GlobalState.cristalHealth) / GlobalState.cristalMaxHealth) * 100)
