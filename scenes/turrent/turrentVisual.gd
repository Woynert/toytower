extends Node3D
class_name TurrentVisual

const headNames = ["head1", "head2", "head3"]

var head: Node3D
var target: Node3D
var spinFactor: float = 0.3

func _ready():
	setup(0)

func setup(index: int):
	
	var root = $turrent1/root
	
	for i in headNames.size():
		var head = root.get_node(headNames[i])
		
		# select head by index
		if i == index:
			self.head = head
			
		# delete the rest
		else:
			head.queue_free()
	
func _physics_process(delta):
	if target == null:
		return
	
	var dir = head.global_position.direction_to(target.global_position)
	var angleDest = Vector2.ZERO.angle_to_point(Vector2(dir.z, dir.x))
	
	# point towards target
	head.rotation.y = lerp_angle(head.rotation.y, angleDest, spinFactor)

func setTarget(node: Node3D):
	target = node
	
func rotateBody(angle: float):
	var root = $turrent1/root
	for node in root.get_children():
		node.rotation.y = angle
	
	
