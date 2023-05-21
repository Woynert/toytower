extends Node3D
class_name TurrentVisual

const HEAD_NAMES = ["head1", "head2", "head3"]

var head: Node3D
var target: Node3D
var stateMachine: AnimationNodeStateMachinePlayback
var spinFactor: float = 0.3

func _ready():
	
	# get animation state machine 
	stateMachine = $AnimationTree.get("parameters/StateMachine/playback")

func setup(index: int):
	
	# show head
	
	var root = $turrent1/root
	
	for i in HEAD_NAMES.size():
		var head = root.get_node(HEAD_NAMES[i])
		
		# select head by index
		if i == index:
			self.head = head
			
		# delete the rest
		else:
			head.queue_free()
			
	# idle animation
	
	stateMachine.start("turrent%d-idle" % (index + 1))
	
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

func playAnimation(animation: String):
	print(animation)
	stateMachine.start(animation)
	
