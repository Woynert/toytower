extends Node3D

@export var ui: UIPlayer
@export var scnTurrent: PackedScene
@export var playerAimPoint: PlayerAimPoint
@export var playerRotatingHead: Node3D

enum STATE{
	NONE,
	ON_TURRENT_MENU,
	PLACING_TURRENT,
	MOVING_TURRENT,
}

# state specific

var selectedTurrentIndex: int = -1
var createdTurrent: Turrent

var state: STATE = STATE.NONE

func setState(state: STATE):
	self.state = state
	
func _physics_process(delta):
	
	match state:
		STATE.NONE:
			
			# open turrent menu
			if Input.is_action_just_pressed("gm_open_turrent_menu"):
				ui.toggleTurrentSelect(true)
				setState(STATE.ON_TURRENT_MENU)
				
		STATE.ON_TURRENT_MENU:
			
			# close turrent menu
			if Input.is_action_just_pressed("gm_open_turrent_menu"):
				ui.toggleTurrentSelect(false)
				setState(STATE.NONE)
				
			elif Input.is_action_just_pressed("gm_pick1"):
				ui.toggleTurrentSelect(false)
				selectedTurrentIndex = 0
				setState(STATE.PLACING_TURRENT)
				createTurrent()
				
			elif Input.is_action_just_pressed("gm_pick2"):
				ui.toggleTurrentSelect(false)
				selectedTurrentIndex = 1
				setState(STATE.PLACING_TURRENT)
				createTurrent()
				
			elif Input.is_action_just_pressed("gm_pick3"):
				ui.toggleTurrentSelect(false)
				selectedTurrentIndex = 2
				setState(STATE.PLACING_TURRENT)
				createTurrent()
				
		STATE.PLACING_TURRENT:
			
			# rotate turrent
			assert(createdTurrent is Turrent)
			assert(playerRotatingHead is Node3D)
			
			createdTurrent.rotateBody(playerRotatingHead.rotation.y + PI)
			
			# cancel placement
			if Input.is_action_just_pressed("gm_escape"):
				print("cancel")
				
			# check colliding body
			if !createdTurrent.isBodyFree():
				return
				
			# place turrent
			if Input.is_action_just_pressed("gm_primary_action"):
				
				# reparent
				var origin = createdTurrent.global_position
				playerAimPoint.getNodePoint().remove_child(createdTurrent)
				get_tree().get_current_scene().add_child(createdTurrent)
				
				# enable
				createdTurrent.global_position = origin
				createdTurrent.enable()
				
				# reset state
				setState(STATE.NONE)
				createdTurrent = null
				selectedTurrentIndex = -1
				
				

func createTurrent():
	assert(scnTurrent is PackedScene)
	assert(playerAimPoint is PlayerAimPoint)
	
	var turrent: Turrent = scnTurrent.instantiate()
	createdTurrent = turrent
	
	playerAimPoint.getNodePoint().add_child(turrent)
	turrent.setup(selectedTurrentIndex)
