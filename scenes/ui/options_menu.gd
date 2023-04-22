extends CanvasLayer
#var vsync = true
#var fullscreen
#var resolution = 1  # 0 is 720p, 1 is fhd, 2 is 1440hd, 3 is 4k.
var resolution_array = ["Auto", Vector2(1280, 720), Vector2(1920,1080), Vector2(2560,1440), Vector2(3840,2160)]

@onready var music_slider = $OptionsBG/MusicVol/MusicSlider.value
@onready var sfx_slider = $OptionsBG/SFXVol/SFXSlider.value
@onready var vsync_button = $OptionsBG/VSync/VsyncButton.button_pressed
@onready var full_button = $OptionsBG/Fullscreen/FullButton.button_pressed

#@onready var music_bus := AudioServer.get_bus_index("Background")
#@onready var sfx_bus := AudioServer.get_bus_index("Effects")

func _ready():
	print("global vsync  ", globals.vsync)
	print("global fullscreen  ", globals.fullscreen)
	# get global audio values
	#AudioServer.set_bus_volume_db( globals.music_bus, linear_to_db(music_vol))
	#AudioServer.set_bus_volume_db(globals.sfx_bus, linear_to_db(sfx_vol))
	
	# match slider state to global audio state
	#music_slider = db_to_linear(AudioServer.get_bus_volume_db(globals.music_bus))
	#sfx_slider = db_to_linear(AudioServer.get_bus_volume_db(globals.sfx_bus))
	music_slider = db_to_linear(globals.music_vol)
	sfx_slider = db_to_linear(globals.sfx_vol)
	print("set music slider to match global")
	
	# get global display values
	globals.fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	globals.vsync = DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED
	
	# match button state to global display state
	vsync_button = globals.vsync
	print("set vsync button to match global")
	full_button = globals.fullscreen
	print("set fullscreen button to match global")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		hide()


func _on_vsync_button_toggled(button_pressed):  # VSync button
	$click.play()
	# set global vsync value
	globals.vsync = !globals.vsync
	
	if globals.vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		print("v yes")
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		print("v no")
		
func _on_full_button_toggled(button_pressed):
	$click.play()
	globals.fullscreen = !globals.fullscreen
	print("fullscreen toggled")
	if globals.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_back_button_pressed():  # Hides on back button pressed
	$click.play()
	hide()


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(globals.music_bus, linear_to_db(value))
	print(linear_to_db(value))
	#print("music vol set")

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(globals.sfx_bus, linear_to_db(value))
	#print("sfx vol set")


func _on_option_button_item_selected(index):
	$click.play()
	if index == 0:
		DisplayServer.window_set_size(DisplayServer.screen_get_size())
	else:
		DisplayServer.window_set_size(resolution_array[index])


func _on_music_slider_drag_started():
	$click.play()


func _on_sfx_slider_drag_started():
	$click.play()



