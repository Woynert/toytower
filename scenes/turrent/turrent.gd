extends Node3D

var target: Node3D
@export var reachDistance: float = 10

var ray: RayCast3D
var visual: TurrentVisual

func _ready():
	ray = $RayCast3D
	visual = $visual
	$timerRetarget.connect("timeout", retarget)
	($Area3D/CollisionShape3D.shape as SphereShape3D).radius = reachDistance

func retarget():
	
	# target still in sight
	
	if target != null:
		if global_position.distance_to(target.global_position) <= reachDistance:
			return
			
	# otherwise find a new target
	
	target = null
	var reachableBodies: Array[Node3D] = $Area3D.get_overlapping_bodies()
	var minDist = reachDistance
	
	for body in reachableBodies:
		
		# check linesight
		
		if !linesightWith(body):
			continue
			
		var dist = global_position.distance_to(body.global_position)
		
		# check distance
		
		if dist < minDist:
			target = body
			minDist = dist
	
	visual.setTarget(target)
	
func linesightWith(node: Node3D) -> bool:
	
	ray.target_position = node.global_position - ray.global_position
	ray.force_update_transform()
	ray.force_raycast_update()
	
	return !ray.is_colliding()
