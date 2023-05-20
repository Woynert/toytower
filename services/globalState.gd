extends Node

var round = 1

var killedEnemies = 0

var cristalMaxHealth = 1000
var cristalHealth = cristalMaxHealth

# game progress

func addEnemyKill():
	killedEnemies += 1
	
func damageCristal(damage: int):
	cristalHealth = max(0, cristalHealth - damage)
	print(cristalHealth)

func advanceRound():
	
	round += 1
	
	# reset state
	
	killedEnemies = 0
	cristalHealth = cristalMaxHealth

# game life cycle

func reset_game():
	round = 1
	killedEnemies = 0
	cristalHealth = cristalMaxHealth
	
	
