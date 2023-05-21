extends CharacterBody3D

@onready var head = $head as Node3D
@onready var camera = $head/ogCamera as Camera3D
@onready var gunRay = $head/ogCamera/gunRay as RayCast3D

var mouseSensibility = 800
var mouseRelativeX = 0
var mouseRelativeY = 0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GRAVITY = 10


func _ready():
	# stops rgun from hitting yourself
	gunRay.add_exception(self)
	
	# captures mouse 
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _physics_process(delta):
	
	if GlobalState.game_state == GlobalState.GAME_STATE.PLAYING:

		# gravity
		if not is_on_floor():
			velocity.y -= GRAVITY * delta

		# jump
		if Input.is_action_just_pressed("gm_jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		# shoot
		if Input.is_action_pressed("gm_primary_action"):
			shoot()
			
		# get the input direction and handle the movement / deceleration.
		var input_dir = Input.get_vector("gm_left", "gm_right", "gm_up", "gm_down")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		
		if GlobalState.game_state != GlobalState.GAME_STATE.PLAYING:
			return
		
		head.rotation.y -= event.relative.x / mouseSensibility
		camera.rotation.x -= event.relative.y / mouseSensibility
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
		mouseRelativeX = clamp(event.relative.x, -50, 50)
		mouseRelativeY = clamp(event.relative.y, -50, 10)

func shoot():
	
	# play animation
	(%visualFPS as PlayerVisualFPS).playAnimation(PlayerVisualFPS.ANI.ATTACK)
	
	"""
	if not gunRay.is_colliding():
		return
	
	print(gunRay.get_collision_point())
	print(gunRay.get_collision_point()+gunRay.get_collision_normal())
	"""
