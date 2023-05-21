extends Node

enum GAME_STATE {
	PLAYING,
	LOST,
	WON
}

signal sig_game_state_changed
signal sig_round_advanced

var game_state: GAME_STATE = GAME_STATE.PLAYING

var round = 1
var winningRound = 3
var killedEnemies = 0
var enemiesToSpawn = 1

var cristalMaxHealth = 100
var cristalHealth = cristalMaxHealth

# game progress

func _ready():
	set_game_state(GAME_STATE.PLAYING)

func addEnemyKill():
	killedEnemies += 1
	
	# check all are dead
	if killedEnemies >= enemiesToSpawn:
		advanceRound()
	
func damageCristal(damage: int):
	cristalHealth = max(0, cristalHealth - damage)
	
	if (cristalHealth <= 0):
		set_game_state(GAME_STATE.LOST)
		
func setEnemiesToSpawn(amount: int):
	enemiesToSpawn = amount

# game life cycle

func advanceRound():
	
	# win
	
	if (round >= winningRound):
		set_game_state(GAME_STATE.WON)
		return
		
	# advance round
	
	round += 1
	sig_round_advanced.emit()
	
	# reset state
	
	killedEnemies = 0
	cristalHealth = cristalMaxHealth

func set_game_state(state: GAME_STATE):
	game_state = state
	sig_game_state_changed.emit()

func reset_game():
	round = 1
	killedEnemies = 0
	cristalHealth = cristalMaxHealth
	
	set_game_state(GAME_STATE.PLAYING)
	
	
	
	
	
