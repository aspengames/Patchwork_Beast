extends Node2D

@onready var textbox = $"../Player/Player/Camera2D/Textbox"
@onready var player = $"../Player/Player"
@onready var mob = $"../mob"

var one = false
var two = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player.get_node("atkTimer").set_wait_time(99999999)
	player.get_node("atkTimer").start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if globals.textbox_finished:
		globals.textbox_finished = false
		globals.player_stop = true
		two = true
		$anim.play_backwards("camera_shift")
	if mob.alive == false and globals.tutorial:
		globals.tutorial = false
		$anim.play("whiteout")
		player.get_node("explosion").emitting = true

func _on_PLAYER_entered(body):
	# Set the keyframe at 2s to be the position
	if body.is_in_group("player") and not one:
		globals.player_stop = true
		$anim.play("camera_shift")
	
func _on_ANIM_finished(anim_name):
	if anim_name == "camera_shift" and not one:
		one = true
		textbox.queue_text("A deer spirit! What are you doing so far from home? I should be closer to the __village than the ___ forest...")
		textbox.queue_text("Wait…what’s that on the deer’s leg? Rust? So strange…it seems to be spreading…")
	if anim_name == "camera_shift" and two:
		player.get_node("atkTimer").set_wait_time(3)
		player.get_node("atkTimer").start()
		player.get_node("ui").visible = true
		player.show_tip("Ah! Someone, anyone, help!")
		two = false
		globals.player_stop = false
		
	
