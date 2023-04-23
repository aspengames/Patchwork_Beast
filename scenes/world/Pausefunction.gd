extends Node2D
var paused_textbox = false
# if pausing a textbox, make sure to temporarily make mouse visible in menu.

# add this script to root node of playable scene trees!

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape") and not $MainMenu.visible:
		if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			paused_textbox = true
		$PauseMenu.show()
		get_tree().paused = true

func _on_pause_menu_unpause():
	get_tree().paused = false
	if paused_textbox:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
