extends Node3D

@export var gunCamera: Camera3D
@export var ogCamera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	
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


