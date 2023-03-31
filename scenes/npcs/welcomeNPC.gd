extends CharacterBody2D

var interacted = false
var can_interact = true

@onready var textbox = $"../../Map/Map/Player/Camera2D/Textbox"
@onready var player = $"../../Map/Map/Player"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if can_interact:
		$Icon.visible = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if interacted:
		_check_interaction()


func _on_hitbox_body_entered(body):
	if body.is_in_group("player") and can_interact:
		#print("interacted")
		interacted = true
		
		
		
func _check_interaction():
	#print(globals.mobs_on_screen)
	if globals.mobs_on_screen < 0:
		globals.mobs_on_screen = 0
	if Input.is_action_just_pressed("interact") and can_interact and globals.mobs_on_screen == 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		textbox.queue_character("Isla")
		textbox.queue_text("So you ran into a Corroded spirit out there, huh?")
		textbox.queue_character("Ramis")
		textbox.queue_text("Sorry! I hadn't realized I was in the spirit forest already...I ran into a strange spirit deer all the way back near Mossglen and thought I'd investigate.")
		textbox.queue_character("Isla")
		textbox.queue_text("Serves you right. No human should be trespassing on our lands.")
		can_interact = false

	if globals.textbox_finished:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		globals.textbox_finished = false
		can_interact = true
		if $Icon.visible:
			$Icon.visible = false


func _on_hitbox_body_exited(body):
	if body.is_in_group("player"):
		#print("interacted")
		interacted = false
		can_interact = true
