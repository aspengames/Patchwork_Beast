extends Node

# Declare member variables here. Examples:
#general
var debug = false
var mobs_on_screen = 0
var textbox_finished = false
var player_stop = false
var tutorial = true
var player_talking = true
var global_dead = false
var dash_enabled = false #false by default
var smash_enabled = false
var allowed_to_shoot = true

var conv_amnt_comp = 0

#mob counts
var deers = 3
var bears = 4

#options menu
var resolution = 1
var fullscreen = false
var vsync = true
var music_bus := AudioServer.get_bus_index("Background")
var sfx_bus := AudioServer.get_bus_index("Effects")
var music_vol = 10 # max 10. THIS IS A LINEAR (not DB value)
var sfx_vol = 10 # max 10. THIS IS A LINEAR (not DB value)

# Called when the node enters the scene tree for the first time.
func _ready():
	#set initial audio
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_vol))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_vol))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
