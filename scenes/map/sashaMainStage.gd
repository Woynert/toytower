extends Node3D

var rng = RandomNumberGenerator.new()
var smHead: AnimationNodeStateMachinePlayback

func _ready():
	rng.randomize()
	smHead = $AnimationTree.get("parameters/StateMachine/playback")
	smHead.start("posing2")
	

# randomly play an animation
func _on_timer_timeout():
	
	var animation = "posing" + str(rng.randi_range(0, 2))
	smHead.travel(animation)
