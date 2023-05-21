extends Node3D
class_name PlayerVisualFPS

enum ANI {
	IDLE,
	ATTACK
}

@export var gunCamera: Camera3D
@export var ogCamera: Camera3D

var stateMachine: AnimationNodeStateMachinePlayback

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# get animation state machine
	
	stateMachine = $AnimationTree.get("parameters/StateMachine/playback")
	
	# set all nodes to render on layer 2
	
	var visualNodes = []
	findByClass(self, "VisualInstance3D", visualNodes)
	
	for node in visualNodes:
		
		(node as VisualInstance3D).layers = 0
		(node as VisualInstance3D).set_layer_mask_value(2, true)

func _process(delta):
	gunCamera.transform = ogCamera.get_camera_transform()

func findByClass(node: Node, className : String, result : Array) -> void:

	if node.is_class(className):
		result.push_back(node)

	for child in node.get_children():
		findByClass(child, className, result)

# animations

func playAnimation(ani: ANI):
	
	match ani:
		ANI.IDLE:
			if stateMachine.get_current_node() != "fps-idle":
				stateMachine.start("fps-idle")
				
		ANI.ATTACK:
			if stateMachine.get_current_node() != "fps-attack":
				stateMachine.start("fps-attack")
				GlobalAudio.play_sound("player-hit")
	

