extends Node2D

@onready var textbox = $"../Map/Map/Player/Camera2D/Textbox"
@onready var player = $"../Map/Map/Player"
@onready var mob = $"../Map/Map/mob"

var one_shot = true
var one = false
var two = false

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioController.play_music()
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
		player.get_node("transition").visible = false
	if mob.alive == false and one_shot:
		$"../trans/anim".play("whiteout")
		player.get_node("explosion").emitting = true

func _on_PLAYER_entered(body):
	# Set the keyframe at 2s to be the position
	if body.is_in_group("player") and not one:
		globals.player_stop = true
		$anim.play("camera_shift")
	
func _on_ANIM_finished(anim_name):
	if anim_name == "camera_shift" and not one:
		one = true
		textbox.queue_text("A deer spirit! What are you doing so far from home? I should be closer to Mossglen village than the enchanted forest...")
		textbox.queue_text("Wait…what’s that on the deer’s leg? Rust? So strange…it seems to be spreading…")
	if anim_name == "camera_shift" and two:
		player.get_node("atkTimer").set_wait_time(1)
		player.get_node("atkTimer").start()
		player.get_node("ui").visible = true
		two = false
		globals.player_stop = false
		await get_tree().create_timer(2).timeout # delay tip to give player time to actually interact w enemy
		#player.show_tip("Ah! Someone, anyone, help!", 3)
		player.show_tip("Click to shoot, press space to dash", 5)
	if anim_name == "whiteout":
		get_tree().change_scene_to_file("res://scenes/world/Level.tscn")
		
	
