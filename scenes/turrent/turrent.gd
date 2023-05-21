extends Node3D
class_name Turrent

const BASE_SHOOT_TIMES = [0.4, 1.2, 2]
const BASE_DAMAGES = [2, 10, 50]

var target: Node3D
var ray: RayCast3D
var visual: TurrentVisual

@export var autoEnable: bool = false
@export var turrentIndex: int = 0
@export var reachDistance: float = 10
var shootTime: float = BASE_SHOOT_TIMES[0]
var damage: float = BASE_DAMAGES[0]

func _ready():
	ray = $RayCast3D
	visual = $visual
	
	($areaShootRange/CollisionShape3D.shape as SphereShape3D).radius = reachDistance
	
	if autoEnable:
		setup(turrentIndex)
		enable()

func setup(index: int):
	turrentIndex = index
	
	damage = BASE_DAMAGES[index]
	visual.setup(index)
	
func enable():
	
	# alarm events
	
	$timerRetarget.connect("timeout", retarget)
	$timerShoot.connect("timeout", shoot)
	
	# start shoot alarm
	
	shootTime = BASE_SHOOT_TIMES[turrentIndex]
	$timerShoot.start(shootTime)
	
	# enable collision
	
	$CharacterBody3D.set_collision_layer_value(1, true)

func shoot():
	
	if GlobalState.game_state != GlobalState.GAME_STATE.PLAYING:
		return
	
	if target == null:
		return
	
	# hurt enemy
	var enemy = target.get_parent()
	assert(enemy is Enemy)
	enemy.hurt(damage)
	
	visual.playAnimation("turrent%d-attack" % (turrentIndex + 1))

func retarget():
	
	# target still in sight
	
	if target != null:
		if global_position.distance_to(target.global_position) <= reachDistance:
			return
			
	# otherwise find a new target
	
	target = null
	var reachableBodies: Array[Node3D] = $areaShootRange.get_overlapping_bodies()
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
	
# for third parties

func rotateBody(angle: float):
	visual.rotateBody(angle)
	
func isBodyFree() -> bool: 
	return !($areaBody.has_overlapping_areas() || $areaBody.has_overlapping_bodies())
