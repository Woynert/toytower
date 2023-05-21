extends Node

enum GAME_STATE {
	PLAYING,
	LOST,
	WON
}

signal sig_game_state_changed

var game_state: GAME_STATE = GAME_STATE.PLAYING

var round = 1
var winningRound = 7
var killedEnemies = 0

var cristalMaxHealth = 100
var cristalHealth = cristalMaxHealth

# game progress

func _ready():
	set_game_state(GAME_STATE.PLAYING)

func addEnemyKill():
	killedEnemies += 1
	
func damageCristal(damage: int):
	cristalHealth = max(0, cristalHealth - damage)
	
	if (cristalHealth <= 0):
		set_game_state(GAME_STATE.LOST)

func advanceRound():
	
	# win
	
	if (round >= winningRound):
		set_game_state(GAME_STATE.WON)
		return
		
	# advance round
	
	round += 1
	
	# reset state
	
	killedEnemies = 0
	cristalHealth = cristalMaxHealth

# game life cycle

func set_game_state(state: GAME_STATE):
	game_state = state
	sig_game_state_changed.emit()

func reset_game():
	round = 1
	killedEnemies = 0
	cristalHealth = cristalMaxHealth
	
	set_game_state(GAME_STATE.PLAYING)
	
	
	
	
	
