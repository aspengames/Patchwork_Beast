extends CanvasLayer

var resolution_array = ["Auto", Vector2(1280, 720), Vector2(1920,1080), Vector2(2560,1440), Vector2(3840,2160)]

@onready var music_slider = $OptionsBG/MusicVol/MusicSlider
@onready var sfx_slider = $OptionsBG/SFXVol/SFXSlider
@onready var vsync_button = $OptionsBG/VSync/VsyncButton
@onready var full_button = $OptionsBG/Fullscreen/FullButton


func _ready():

	# set initial slider value to match global audio state
	music_slider.set_value_no_signal(globals.music_vol)
	print("ready set music slider to  ", globals.music_vol)
	sfx_slider.set_value_no_signal(globals.sfx_vol)

	# set initial button state to match global display state
	vsync_button.set_pressed_no_signal(globals.vsync)
	print("ready set vsync button to ", globals.vsync)
	full_button.set_pressed_no_signal(globals.fullscreen)
	print("ready set vsync button to ", globals.fullscreen)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		$click.play()
		hide()


func _on_vsync_button_toggled(button_pressed):  # VSync button
	$click.play()
	# set global vsync value
	globals.vsync = !globals.vsync
	# set actual vsync
	if globals.vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		#print("v on")
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		#print("v off")
		
func _on_full_button_toggled(button_pressed):
	$click.play()
	# set global fullscreen value
	globals.fullscreen = !globals.fullscreen
	if globals.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		#print("full on")
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		#print("full off")

func _on_back_button_pressed():  # Hides on back button pressed
	$click.play()
	hide()


func _on_music_slider_value_changed(value):
	# set new globals value
	globals.music_vol = value
	AudioServer.set_bus_volume_db(globals.music_bus, linear_to_db(globals.music_vol))
	#print("music vol set")

func _on_sfx_slider_value_changed(value):
	globals.sfx_vol = value
	AudioServer.set_bus_volume_db(globals.sfx_bus, linear_to_db(globals.sfx_vol))
	#print("sfx vol set")


func _on_option_button_item_selected(index):
	$click.play()
	globals.resolution = index
	if globals.resolution == 0:
		DisplayServer.window_set_size(DisplayServer.screen_get_size())
	else:
		DisplayServer.window_set_size(resolution_array[globals.resolution])


func _on_music_slider_drag_started():
	$click.play()
func _on_sfx_slider_drag_started():
	$click.play()

func _on_visibility_changed():
	# make all slider/button states match global values, even when accessing different OptionsMenu instance.
	# set all values
	music_slider.set_value_no_signal(globals.music_vol)
	print("visibility change, set music slider to  ", globals.music_vol)
	sfx_slider.set_value_no_signal(globals.sfx_vol)

	# set initial button state to match global display state
	vsync_button.set_pressed_no_signal(globals.vsync)
	full_button.set_pressed_no_signal(globals.fullscreen)
	print("visibility change, set vsync button to  ", vsync_button.button_pressed, " and fullscreen to ", full_button.button_pressed)
