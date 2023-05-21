extends Node3D

@export var ray: RayCast3D

func _physics_process(delta):
	
	assert(ray is RayCast3D)
	
	if !ray.is_colliding():
		$aimPoint.visible = false
		return
	
	if ray.get_collision_normal().y < 0.6:
		$aimPoint.visible = false
		return
		
	$aimPoint.visible = true
	$aimPoint.global_position = ray.get_collision_point()
