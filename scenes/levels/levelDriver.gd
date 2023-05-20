extends Node

var difficulty = 0
var round = 1
var enemiesToSpawn = 1
var enemiesSpawned = 1

# health
# speed

const enemiesBaseStats = [
	[100, 0.055],
	[200, 0.05],
	[500, 0.02]
]

# base enemy index
# health factor
# speed factor
# scale factor

const enemiesPerRound = [
	# easy: A, A lite, B, B lite
	[
		[0, 1, 1, 1],
		[0, 0.25, 1.2, 0.5],
		[1, 1, 1, 1],
		[1, 0.25, 1.6, 0.6],
	],
	
	# medium: A big, B, C lite
	[
		[0, 1.5, 0.8, 1.3],
		[1, 1, 1, 1],
		[2, 0.25, 1, 0.6]
	],
	
	# hard: B big, C, C big, A big, B lite
	[
		[1, 1.5, 1, 1.2],
		[2, 1, 1, 1],
		[2, 1.2, 0.8, 1.3],
		[0, 1.5, 0.8, 1.3],
		[1, 0.25, 1.6, 0.6],
	]
]

var currentEnemies = enemiesPerRound[difficulty]

@export var scnEnemy: PackedScene

func _ready():
	randomize()
	$timerSpawn.connect("timeout", _on_spawn_timeout)
	$timerSpawn.start()
	
	# setup round 1
	setup_round(round)
	
func setup_round(newRound: int):
	
	round = newRound
	
	if round > 6:
		difficulty = 2
	elif round > 3:
		difficulty = 1
	else:
		difficulty = 0
	
	currentEnemies = enemiesPerRound[difficulty]
	enemiesSpawned = 0
	enemiesToSpawn = round * 15

func _on_spawn_timeout():
	
	# enemies are all killed
	
	if (enemiesSpawned < enemiesToSpawn):
		
		# select a random spawn
		
		var paths = $enemyPaths.get_children()
		var spawn: Node3D = paths[randi_range(0, paths.size()-1)].get_node("spawn")
		if (spawn == null):
			print("Error could not find spawn")
			return
		
		# spawn a enemy there
		
		var enemy: Enemy = scnEnemy.instantiate()
		spawn.add_sibling(enemy)
		enemy.global_position = spawn.global_position
		
		# setup enemy
		
		# get random enemy from current wave
		
		var enemyStats = currentEnemies[randi_range(0, currentEnemies.size() -1)]
		var index = enemyStats[0]
		
		enemy.setup(
			index,
			enemyStats[1] * enemiesBaseStats[index][0],
			enemyStats[2] * enemiesBaseStats[index][1],
			enemyStats[3]
		)

		enemiesSpawned += 1

