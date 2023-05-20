extends PathFollow3D
class_name Enemy

var speed: float = 0
var maxHealth: int = 1
var health: int = maxHealth
var attackSpeed: float = 1
var damage: float = 1

var arrived: bool = false

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
	self.speed = speed
	self.attackSpeed = attackSpeed
	self.damage = damage
	
	$enemyVisual.scale = Vector3.ONE * scale * (0.3 + randf_range(-0.05, 0.05))
	($enemyVisual as EnemyVisual).selectEnemy(enemyIndex)
	($enemyVisual as EnemyVisual).setAnimationState(EnemyVisual.ANI_STATE.WALK)
	($enemyVisual as EnemyVisual).setAnimationSpeed(speed * 50)

func _physics_process(delta):
	
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

