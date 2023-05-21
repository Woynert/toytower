extends Node3D

const SHOOT_TIMES = [1, 1.2, 1.1]

var target: Node3D
var ray: RayCast3D
var visual: TurrentVisual

@export var turrentIndex: int = 0
@export var reachDistance: float = 10
var shootTime: float = SHOOT_TIMES[0]

func _ready():
	ray = $RayCast3D
	visual = $visual
	
	($Area3D/CollisionShape3D.shape as SphereShape3D).radius = reachDistance
	
	$timerRetarget.connect("timeout", retarget)
	$timerShoot.connect("timeout", shoot)
	
	setup(turrentIndex)
	enable()

func setup(index: int):
	turrentIndex = index
	visual.setup(index)
	
func enable():
	# start shoot alarm
	
	shootTime = SHOOT_TIMES[turrentIndex]
	$timerShoot.start(shootTime)

func shoot():
	
	if target == null:
		return
		
	visual.playAnimation("turrent%d-attack" % (turrentIndex + 1))

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
