extends CanvasLayer
@onready var player = $"../Player/Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	if globals.tutorial and get_tree().current_scene.name != "Tutorial":
		player.get_node("transition").visible = false
		$anim.play_backwards("whiteout")
		globals.player_talking = false
		globals.mobsight = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
