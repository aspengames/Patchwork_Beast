extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		$PauseMenu.show()
		get_tree().paused = true


func _on_pause_menu_unpause():
	get_tree().paused = false
