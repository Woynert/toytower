extends Node

@export var spawnTimeout: float = 3

var difficulty = 0
var enemiesSpawned = 1

# health
# speed
# attack speed
# damage

const enemiesBaseStats = [
	[100, 0.055, 1.6, 5],
	[120, 0.05, 1.5, 8],
	[500, 0.02, 3, 15]
]

# base enemy index
# health factor
# speed factor
# damage factor
# scale factor

const enemiesPerRound = [
	# easy: A, A lite, B, B lite
	[
		[0, 1, 1, 1, 0.8],
		[0, 0.25, 1.2, 0.5, 0.5],
		[1, 1, 1, 1, 1],
		[1, 0.25, 1.6, 0.5, 0.7],
	],
	
	# medium: A big, B, C lite
	[
		[0, 1.5, 0.8, 1.5, 1.1],
		[1, 1, 1, 1, 1],
		[2, 0.25, 1, 0.5, 0.7]
	],
	
	# hard: B big, C, C big, A big, B lite
	[
		[1, 1.5, 1, 1.5, 1.1],
		[2, 1, 1, 1, 0.9],
		[2, 1.2, 0.8, 1.5, 1.2],
		[0, 1.5, 0.8, 1.5, 1.1],
		[1, 0.25, 1.6, 0.5, 0.7],
	]
]

var currentEnemies = enemiesPerRound[difficulty]

@export var scnEnemy: PackedScene

func _ready():
	randomize()
	
	# events
	$timerSpawn.connect("timeout", _on_spawn_timeout)
	$timerSpawn.start(spawnTimeout)
	GlobalState.connect("sig_round_advanced", setup_round)
	
	# setup round 1
	setup_round()
	
func setup_round():
	
	if GlobalState.round >= 6:
		difficulty = 2
	elif GlobalState.round >= 3:
		difficulty = 1
	else:
		difficulty = 0
	
	currentEnemies = enemiesPerRound[difficulty]
	enemiesSpawned = 0
	GlobalState.setEnemiesToSpawn(1 + GlobalState.round * 5)

func _on_spawn_timeout():
	
	# enemies are all killed
	
	if (enemiesSpawned < GlobalState.enemiesToSpawn):
		
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
			max(1, ceil(enemyStats[3] * enemiesBaseStats[index][3])),
			enemyStats[4],
			enemiesBaseStats[index][2],
		)

		enemiesSpawned += 1
		
	# slightly change spawn wait time
	
	$timerSpawn.start(spawnTimeout + randf_range(-1, 1))

