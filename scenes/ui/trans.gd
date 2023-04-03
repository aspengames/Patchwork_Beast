extends CanvasLayer
@onready var player = $"../NAV/Map/Map/Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	if globals.tutorial and get_tree().current_scene.name != "Tutorial":
		globals.player_stop = false
		if globals.global_dead:
			player.get_node("transition/ColorRect").color = Color(0,0,0,255)
			globals.global_dead = false
			$anim.play_backwards("blackout")
		else:
			player.get_node("transition").visible = false
			$anim.play_backwards("whiteout")
		globals.player_talking = false
		globals.mobs_on_screen = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
