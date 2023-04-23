extends CharacterBody2D

var interacted = false
var can_interact = true

@onready var textbox = $"../Player/Camera2D/Textbox"
@onready var player = $"../Player"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var NPC_Spriteframes: Resource


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.sprite_frames = NPC_Spriteframes
	$AnimatedSprite2D.play("idle")
	if can_interact:
		$Icon.visible = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if interacted:
		#print("self name is ", self.name)
		_check_interaction(self.name)


func _on_hitbox_body_entered(body):
	if body.is_in_group("player") and can_interact:
		#print("interacted")
		interacted = true
		
		
		
func _check_interaction(npc):
	#print(globals.mobs_on_screen)
	if globals.mobs_on_screen < 0:
		globals.mobs_on_screen = 0
	if Input.is_action_just_pressed("interact") and can_interact and globals.mobs_on_screen == 0:
		$interact.play()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		# Available player expressions: Ramis(Player), PlayerShock, PlayerConcern, PlayerLaugh, PlayerApology, PlayerCat
		match npc:
			"Isla":
				textbox.queue_character("Isla")
				textbox.queue_text("What is a human like you doing in our forest?")
				textbox.queue_character("PlayerApology")
				textbox.queue_text("Sorry, I hadn't realized I was in the spirit forest already...I was injured by a strange spirit deer all the way back near Mossglen and thought I'd investigate.")
				textbox.queue_character("Isla")
				textbox.queue_text("Serves you right. No human should be meddling in our matters.")
			"Ilya":
				textbox.queue_character("Shopkeep")
				textbox.queue_text("Hah, so you're the newest lad that our Healer recruited to cleanse the forest, eh?")
				textbox.queue_character("Ramis")
				textbox.queue_text("That's me now, I guess!")
				textbox.queue_character("Shopkeep")
				textbox.queue_text("Between you and me, I'd turn around. Mossglen's already done for--don't risk your life for this.")
				textbox.queue_character("PlayerConcern")
				textbox.queue_text("Healer's already been so generous. I promised I'd help.")
			"Iliea":
				textbox.queue_character("Healer")
				textbox.queue_text("Oh, you're awake! Ran into a Corroded spirit out there, huh? Thank the gods I found you passed out right at the edge of Mossglen.")
				textbox.queue_character("PlayerShock")
				textbox.queue_text("So that's what that was?!")
				textbox.queue_character("Healer")
				textbox.queue_text("You're lucky, you know! Must be that magic staff--haven't seen anyone run into a Corroded spirit who didn't come out Corroded themselves.")
				textbox.queue_character("Healer")
				textbox.queue_text("Several villagers have already succumbed to it. No one knows why it's spreading from the enchanted forest up north, and no one's brave enough to find out.")
				textbox.queue_character("PlayerApology")
				textbox.queue_text("Well...I didn't know my staff could cure Corrosion, but I guess I could help?")
				textbox.queue_character("Healer")
				textbox.queue_text("Perfect! Welcome to Mossglen, new resident. Go talk to the shopkeep and he'll have your room and board taken care of!")
				textbox.queue_character("PlayerShock")
				textbox.queue_text("Wait, wait, what?")
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
