extends CanvasLayer
@onready var optionsoverlay = $OptionsMenu/Overlay
@onready var player = $"../NAV/Map/Map/Player"
@onready var options = $OptionsMenu

signal unpause
# PauseMenu.tscn is the pause menu ONLY. It must be called by the pausefunction.gd script,
# which it passes the signal unpause to.
@onready var textbox
func _ready():
	textbox = get_tree().current_scene.get_node("NAV/Map/Map/Player/Camera2D/Textbox")
	# when calling the options menu via the pause menu, don't duplicate the bg overlays.
	optionsoverlay.hide()

func _process(delta):
	pass

func _on_resume_pressed():
	print("game resumed")
	$Overlay.hide()
	$PauseBG.hide()
	unpause.emit()
	if not textbox.get_node("TextboxContainer").visible:
		globals.player_stop = false
	await get_tree().create_timer(0.3).timeout
	hide()
	
func _on_options_pressed():
	$click.play()
	$OptionsMenu.visible = true

func _on_quit_pressed():
	# may implement quit to main menu instead of quit game in the future. under construction.
	#get_tree().quit() #NO
	get_tree().paused = true
	#get_tree().change_scene("res://scenes/world/Level.tscn")
	options.get_node("click").play()
	print("PARENT")
	print(get_parent())
	print("SELF")
	print(self)
	get_tree().change_scene_to_file("res://scenes/tutorial/tutorial1.tscn")
	#for child in get_parent().get_node("MainMenu").get_children():
	#	child.show()
	#$OptionsMenu.visible = false
	
	
	#player.get_node("transition/anim").seek(0,0)
	#player.get_node("transition").visible = true
	#player.get_node("transition/anim").play("fade")
	
	
