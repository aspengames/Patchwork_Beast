extends CanvasLayer
var vsync = true
var resolution = 1  # 0 is 720p, 1 is fhd, 2 is 1440hd, 3 is 4k.
var resolution_array = ["Auto", Vector2(1280, 720), Vector2(1920,1080), Vector2(2560,1440), Vector2(3840,2160)]

@onready var music_vol = $OptionsBG/MusicSlider.value
@onready var sfx_vol = $OptionsBG/SFXSlider.value
@onready var music_bus := AudioServer.get_bus_index("Background")
@onready var sfx_bus := AudioServer.get_bus_index("Effects")

func _ready():
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_vol))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_vol))
	# setting default audio values
	
	music_vol = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	sfx_vol = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_check_button_toggled(button_pressed):  # VSync button
	$click.play()
	vsync = !vsync
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		#print("v yes")
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		#print("v no")


func _on_back_button_pressed():  # Hides on back button pressed
	$click.play()
	hide()


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))
	#print("music vol set")

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))
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
