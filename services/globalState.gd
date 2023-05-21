extends Node

enum GAME_STATE {
	PLAYING,
	LOST,
	WON
}

signal sig_game_state_changed
signal sig_round_advanced

var game_state: GAME_STATE = GAME_STATE.PLAYING
const winningRound = 8
const cristalMaxHealth = 100

# rounds

var round = 1
var killedEnemies = 0
var enemiesToSpawn = 1
var cristalHealth = cristalMaxHealth

# player

var money = 0

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
	
	if cristalHealth <= 0 && game_state != GAME_STATE.LOST:
		set_game_state(GAME_STATE.LOST)
		
func setEnemiesToSpawn(amount: int):
	enemiesToSpawn = amount
	
# player

func addMoney(amount):
	money += amount
	
func spendMoney(amount):
	assert(amount <= money)
	money -= amount

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
	
	GlobalAudio.play_sound("loose")

func set_game_state(state: GAME_STATE):
	game_state = state
	sig_game_state_changed.emit()

func reset_game():
	
	money = 110
	round = 1
	killedEnemies = 0
	enemiesToSpawn = 1
	cristalHealth = cristalMaxHealth
	
	set_game_state(GAME_STATE.PLAYING)
	
	
	
	
	
