extends CanvasLayer
@onready var optionsoverlay = $OptionsMenu/Overlay
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
	get_tree().quit()
