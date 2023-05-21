extends Node3D

@export var uiPlayer: UIPlayer
@export var uiPause: UIPauseMenu
@export var scnTurrent: PackedScene
@export var playerAimPoint: PlayerAimPoint
@export var playerRotatingHead: Node3D
@export var rangeHalo: Node3D

enum STATE{
	NONE,
	ON_TURRENT_MENU,
	ON_PAUSE_MENU,
	PLACING_TURRENT,
	MOVING_TURRENT,
}

# state specific

var selectedTurrentIndex: int = -1
var createdTurrent: Turrent

var state: STATE = STATE.NONE

func setState(state: STATE):
	self.state = state
	
func _ready():
	uiPause.connect("sig_close", closePauseMenu)
	
func _physics_process(delta):
	
	match state:
		STATE.NONE:
			
			# open turrent menu
			if Input.is_action_just_pressed("gm_open_turrent_menu"):
				uiPlayer.toggleTurrentSelect(true)
				GlobalAudio.play_sound("beep2")
				setState(STATE.ON_TURRENT_MENU)
				
		STATE.ON_TURRENT_MENU:
			
			# close turrent menu
			if (Input.is_action_just_pressed("gm_open_turrent_menu") ||
				Input.is_action_just_pressed("gm_escape")):
				uiPlayer.toggleTurrentSelect(false)
				setState(STATE.NONE)
				
			elif Input.is_action_just_pressed("gm_pick1"):
				if GlobalState.money < DATA.turrent_prices[0]:
					return
					
				uiPlayer.toggleTurrentSelect(false)
				GlobalAudio.play_sound("beep2")
				selectedTurrentIndex = 0
				setState(STATE.PLACING_TURRENT)
				createTurrent()
				
			elif Input.is_action_just_pressed("gm_pick2"):
				if GlobalState.money < DATA.turrent_prices[1]:
					return
					
				uiPlayer.toggleTurrentSelect(false)
				GlobalAudio.play_sound("beep2")
				selectedTurrentIndex = 1
				setState(STATE.PLACING_TURRENT)
				createTurrent()
				
			elif Input.is_action_just_pressed("gm_pick3"):
				if GlobalState.money < DATA.turrent_prices[2]:
					return
					
				uiPlayer.toggleTurrentSelect(false)
				GlobalAudio.play_sound("beep2")
				selectedTurrentIndex = 2
				setState(STATE.PLACING_TURRENT)
				createTurrent()
				
		STATE.PLACING_TURRENT:
			
			# rotate turrent
			assert(createdTurrent is Turrent)
			assert(playerRotatingHead is Node3D)
			
			rangeHalo.visible = false
			createdTurrent.rotateBody(playerRotatingHead.rotation.y + PI)
			
			# cancel placement -> delete turrent
			if (Input.is_action_just_pressed("gm_escape") || 
				Input.is_action_just_pressed("gm_open_turrent_menu")):
				
				playerAimPoint.getNodePoint().remove_child(createdTurrent)
				createdTurrent.queue_free()
				
				# reset state
				setState(STATE.NONE)
				createdTurrent = null
				selectedTurrentIndex = -1
				return
				
			# check colliding body
			if !createdTurrent.isBodyFree():
				return
				
			# show halo
			rangeHalo.visible = true
			
			# TODO: move turrent
			rangeHalo.scale.x = Turrent.BASE_RANGES[selectedTurrentIndex]
			rangeHalo.scale.z = Turrent.BASE_RANGES[selectedTurrentIndex]
				
			# place turrent
			if Input.is_action_just_pressed("gm_primary_action"):
				
				# reparent
				var origin = createdTurrent.global_position
				playerAimPoint.getNodePoint().remove_child(createdTurrent)
				get_tree().get_current_scene().add_child(createdTurrent)
				
				# enable
				createdTurrent.global_position = origin
				createdTurrent.enable()
				
				# update state
				GlobalState.spendMoney(DATA.turrent_prices[selectedTurrentIndex])
				setState(STATE.NONE)
				createdTurrent = null
				selectedTurrentIndex = -1
				rangeHalo.visible = false
				GlobalAudio.play_sound("build")
				
		STATE.ON_PAUSE_MENU:
			
			# close escape menu
			if Input.is_action_just_pressed("gm_escape"):
				uiPause.togglePauseMenu(false)
				setState(STATE.NONE)

func createTurrent():
	assert(scnTurrent is PackedScene)
	assert(playerAimPoint is PlayerAimPoint)
	
	var turrent: Turrent = scnTurrent.instantiate()
	createdTurrent = turrent
	
	playerAimPoint.getNodePoint().add_child(turrent)
	turrent.setup(selectedTurrentIndex)
	
func closePauseMenu():
	setState(STATE.NONE)
