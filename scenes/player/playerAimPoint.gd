extends Node3D
class_name PlayerAimPoint

@export var ray: RayCast3D
var available: bool = false

func _physics_process(delta):
	
	assert(ray is RayCast3D)
	
	if !ray.is_colliding():
		$aimPoint.visible = false
		available = false
		return
	
	if ray.get_collision_normal().y < 0.6:
		$aimPoint.visible = false
		available = false
		return
		
	available = true
	$aimPoint.visible = true
	$aimPoint.global_position = ray.get_collision_point()
	#$aimPoint.global_position.y += 0.1
	
func getNodePoint() -> Node3D:
	return $aimPoint
	
func isPointAvailable() -> bool:
	return available
