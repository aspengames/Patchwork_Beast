extends CanvasLayer


@onready var p1 = $Pointer/selector1
@onready var p2 = $Pointer/selector2
@onready var p3 = $Pointer/selector3

@onready var player = $"../NAV/Map/Map/Player"
@onready var options = $OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	if globals.debug:
		_on_PLAY_pressed()
	pass # Replace with function body.
	if get_tree().current_scene.name == "Tutorial":
		get_tree().paused = true


func _on_PLAY_pressed():
	get_tree().paused = false
	#get_tree().change_scene("res://scenes/world/Level.tscn")
	options.get_node("click").play()
	for child in self.get_children():
		child.hide()
	player.get_node("transition").visible = true
	player.get_node("transition/anim").play("fade")
	
func _on_main_menu_visibility_changed():
	pass

func _on_QUIT_pressed():
	options.get_node("click").play()
	get_tree().quit()
	
func _on_PLAY_mouse_entered():
	p1.modulate = Color(1,1,1,1)
	p2.modulate = Color(1,1,1,0)
	p3.modulate = Color(1,1,1,0)

func _on_OPTIONS_mouse_entered():
	p2.modulate = Color(1,1,1,1)
	p1.modulate = Color(1,1,1,0)
	p3.modulate = Color(1,1,1,0)
	
func _on_QUIT_mouse_entered():
	p3.modulate = Color(1,1,1,1)
	p1.modulate = Color(1,1,1,0)
	p2.modulate = Color(1,1,1,0)
	
func _on_PLAY_focus_entered():
	_on_PLAY_mouse_entered()
	
func _on_OPTIONS_focus_entered():
	_on_OPTIONS_mouse_entered()

func _on_QUIT_focus_entered():
	_on_QUIT_mouse_entered()


func _on_OPTIONS_pressed():
	options.get_node("click").play()
	options.show()
	#print("show options")
