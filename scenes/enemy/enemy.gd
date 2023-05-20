extends PathFollow3D
class_name Enemy

var speed: float = 0
var maxHealth: int = 1
var health: int = maxHealth

func setup(enemyIndex: int, maxHealth: int, speed: float, scale: float):
	
	self.maxHealth = maxHealth
	self.speed = speed
	$enemyVisual.scale = Vector3.ONE * scale * 0.5
	($enemyVisual as EnemyVisual).selectEnemy(enemyIndex)

func _physics_process(delta):
	
	self.progress += speed
