extends PathFollow3D
class_name Enemy

var speed: float = 0
var maxHealth: int = 1
var health: int = maxHealth

func _ready():
	$timerAttack.connect("timeout", attack)

func setup(enemyIndex: int, maxHealth: int, speed: float, scale: float):
	
	self.maxHealth = maxHealth
	self.speed = speed
	$enemyVisual.scale = Vector3.ONE * scale * 0.3
	($enemyVisual as EnemyVisual).selectEnemy(enemyIndex)
	($enemyVisual as EnemyVisual).setAnimationState(EnemyVisual.ANI_STATE.WALK)
	($enemyVisual as EnemyVisual).setAnimationSpeed(speed * 50)

func _physics_process(delta):
	
	self.progress += speed
	
	if (self.progress_ratio == 1):
		$timerAttack.start()
		
func attack():
	print("attack")
	

