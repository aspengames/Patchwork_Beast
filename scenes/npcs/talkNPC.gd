extends CharacterBody2D

var interacted = false
var can_interact = true
@onready var textbox = $"../../Player/Player/Camera2D/Textbox"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#ORIGINAL NPC

# Called when the node enters the scene tree for the first time.
func _ready():
	#textbox.set_new_name("Liria")  #set name to NPC's name
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
	if Input.is_action_just_pressed("interact") and can_interact and not globals.mobsight:
		textbox.queue_text("Ew... a human...")
		textbox.queue_text("Why do you even come around these parts?")
		can_interact = false


func _on_hitbox_body_exited(body):
	if body.is_in_group("player"):
		#print("interacted")
		interacted = false
		can_interact = true
