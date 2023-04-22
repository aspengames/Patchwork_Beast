extends CanvasLayer
@onready var optionsoverlay = $OptionsMenu/Overlay
signal unpause

# Called when the node enters the scene tree for the first time.
func _ready():
	optionsoverlay.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# prevent duplicate overlays


func _on_resume_pressed():
	print("game resumed")
	$click.play()
	await get_tree().create_timer(0.3).timeout
	hide()
	unpause.emit()



func _on_options_pressed():
	$click.play()
	$OptionsMenu.visible = true


func _on_quit_pressed():
	$click.play()
	#quits game (do you want this to quit to main menu?)
	get_tree().quit()
