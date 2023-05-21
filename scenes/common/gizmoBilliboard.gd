extends Node3D
class_name GizmoBilliboard

var speed = 0.02
var speedAlpha = 0.015

func setup(text: String, color: Color = Color.WHITE):
	$Label3D.text = text
	$Label3D.modulate = color
	
func _physics_process(delta):
	$Label3D.global_position.y += speed
	$Label3D.transparency += speedAlpha
	
	if $Label3D.transparency >= 1:
		queue_free()
	
	
