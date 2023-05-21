extends Node

var global_music: AudioStreamPlayer
var sample: AudioStreamWAV
var samples: Dictionary = {
	"beep" : preload("res://assets/sfx/beep.wav"),
	"beep2" : preload("res://assets/sfx/beep2.wav"),
	"build" : preload("res://assets/sfx/build.wav"),
	"canon" : preload("res://assets/sfx/canon.wav"),
	"enemy-die" : preload("res://assets/sfx/robot-spawn.wav"),
	"enemy-hit" : preload("res://assets/sfx/enemy-hit.wav"),
	"loose" : preload("res://assets/sfx/loose.wav"),
	"player-hit" : preload("res://assets/sfx/player-hit.wav"),
	"robot-spawn" : preload("res://assets/sfx/enemy-die.wav"),
	"turrent-shot" : preload("res://assets/sfx/turrent-shot.wav"),
	}
	
func _ready():
	create_global_music_player()
	
func create_global_music_player():
	
	if (!self.global_music):
		self.global_music = AudioStreamPlayer.new()
	
	if (self.global_music.get_parent() != self):
		self.add_child(self.global_music)

func stop_global_music():
	if (self.global_music):
		self.global_music.playing = false

func set_global_music(sfxName: String, pitch: float = 1.0, volumen_db: float = 0):
	
	create_global_music_player()
	config_sound(sfxName, pitch, volumen_db, self.global_music)

func play_sound(sfxName: String, pitch: float = 1.0, volumen_db: float = 0):
	config_sound(sfxName, pitch, volumen_db)

func config_sound(
	sfxName: String,
	pitch: float = 1.0,
	volumen_db: float = 0,
	existingPlayer: AudioStreamPlayer = null
	) -> AudioStreamPlayer:
	
	if (!samples.has(sfxName)):
		print("ERROR: track %s not found" % sfxName)
		return null
		
	# get or create audio stream player
	
	var player: AudioStreamPlayer
	
	if (existingPlayer):
		player = existingPlayer
	else:
		player = AudioStreamPlayer.new()
		self.add_child(player)
		#player.connect("finished", self, "deleteAudioPlayer", [player])
		player.connect("finished", Callable(deleteAudioPlayer).bind(player))
	
	# play
	
	if (player.stream != samples[sfxName]):
		player.stream = samples[sfxName]
		player.autoplay = true
		
	if (!player.playing):
		player.playing = true
		
	player.pitch_scale = pitch
	player.volume_db = volumen_db
	
	
	return player

func deleteAudioPlayer(audio: AudioStreamPlayer):
	audio.queue_free()

