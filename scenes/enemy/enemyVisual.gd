extends Node3D
class_name EnemyVisual

enum ANI_STATE {
	IDLE,
	WALK,
	ATTACK
}

var rootNode: Node3D
var aniTree: AnimationTree
var stateMachine: AnimationNodeStateMachinePlayback

# select which model to use

func selectEnemy(index: int):
	var children = get_children()
	rootNode = children[index]
	
	# delete the rest
	
	for child in children:
		if child != rootNode:
			child.queue_free()
			
	# get state machine 
	
	stateMachine = rootNode.get_node("AnimationTree").get("parameters/playback")
	setAnimationState(ANI_STATE.IDLE)

func setAnimationState (state: ANI_STATE):
	
	if stateMachine == null:
		return
		
	match state:
		ANI_STATE.IDLE:
			stateMachine.start("idle")
		ANI_STATE.WALK:
			stateMachine.start("walk")
		ANI_STATE.ATTACK:
			stateMachine.start("attack")
			
