extends Node3D

var rng = RandomNumberGenerator.new()
var smHead: AnimationNodeStateMachinePlayback

func _ready():
	rng.randomize()
	smHead = $AnimationTree.get("parameters/StateMachine/playback")
	

# randomly play an animation
func _on_timer_timeout():
	
	var animation = "posing" + str(rng.randi_range(1, 2))
	smHead.start(animation)
