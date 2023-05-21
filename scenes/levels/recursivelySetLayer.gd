extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():

	var visualNodes = []
	findByClass(self, "StaticBody3D", visualNodes)
	print("--->", visualNodes.size())
	
	for node in visualNodes:
		var col = node as StaticBody3D
		col.set_collision_layer_value(2, true)
	
func findByClass(node: Node, className : String, result : Array) -> void:

	if node.is_class(className):
		result.push_back(node)

	for child in node.get_children():
		findByClass(child, className, result)
