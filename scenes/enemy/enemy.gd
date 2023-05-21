extends PathFollow3D
class_name Enemy

var speed: float = 0
var maxHealth: int = 1
var health: int = maxHealth
var attackSpeed: float = 1
var damage: float = 1

var arrived: bool = false

@export var damageBilliboard: PackedScene

func _ready():
	$timerAttack.connect("timeout", attack)

func setup(
	enemyIndex: int,
	maxHealth: int,
	speed: float,
	damage: float,
	scale: float,
	attackSpeed: float
	):
	
	self.maxHealth = maxHealth
	self.health = maxHealth
	self.speed = speed
	self.attackSpeed = attackSpeed
	self.damage = damage
	
	$enemyVisual.scale = Vector3.ONE * scale * (0.3 + randf_range(-0.05, 0.05))
	($enemyVisual as EnemyVisual).selectEnemy(enemyIndex)
	($enemyVisual as EnemyVisual).setAnimationState(EnemyVisual.ANI_STATE.WALK)
	($enemyVisual as EnemyVisual).setAnimationSpeed(speed * 50)

func _physics_process(delta):
	
	if GlobalState.game_state != GlobalState.GAME_STATE.PLAYING:
		return
	
	# move along path
	
	self.progress += speed
	
	if (self.progress_ratio > 1 && !arrived):
		
		arrived = true
		$timerAttack.start(attackSpeed)
		
		attack()
		($enemyVisual as EnemyVisual).setAnimationSpeed(1)

func attack():
	($enemyVisual as EnemyVisual).setAnimationState(EnemyVisual.ANI_STATE.ATTACK)
	
	# damage cristal
	GlobalState.damageCristal(self.damage)
	
func hurt(damage: int):
	health = max(0, health - damage)
	
	# create gizmo
	
	var gizmo: GizmoBilliboard = damageBilliboard.instantiate()
	gizmo.setup("-%d" % damage)
	
	get_tree().get_current_scene().add_child(gizmo)
	gizmo.global_position = self.global_position
	gizmo.global_position.y += 2
	
	if health == 0:
		die()
		
func die():
	
	GlobalState.addEnemyKill()
	queue_free()

