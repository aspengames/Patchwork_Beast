extends CharacterBody2D

var interacted = false
var can_interact = true

@onready var textbox = $"../Player/Camera2D/Textbox"
@onready var player = $"../Player"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var NPC_Spriteframes: Resource
@onready var interact
# Called when the node enters the scene tree for the first time.

var isla_lvl = 0
var ilya_lvl = 0
var iliea_lvl = 0

func _ready():
	$AnimatedSprite2D.sprite_frames = NPC_Spriteframes
	$AnimatedSprite2D.play("idle")
	if can_interact:
		$Icon.visible = true
	interact = player.get_node("Interact_UI")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if interacted:
		#print("self name is ", self.name)
		_check_interaction(self.name)

func setDiscordRP(chara):
	if globals.discord_enabled:
		print("UPDATED DISCORD RP")
#		discord_sdk.state = ""
#		discord_sdk.large_image = "mossglen"
#		discord_sdk.large_image_text = "Mossglen Village"
#		match chara:
#			"Isla":
#				discord_sdk.large_image = "forest2"
#				discord_sdk.large_image_text = "Forest"
#				discord_sdk.details = "Talking to Isla"
#				discord_sdk.small_image = "isla"
#				discord_sdk.small_image_text = "Isla"
#			"Ilya":
#				discord_sdk.details = "Talking to Henrik"
#				discord_sdk.small_image = "shopkeep"
#				discord_sdk.small_image_text = "Henrik"
#			"Iliea":
#				discord_sdk.details = "Talking to Miriam"
#				discord_sdk.small_image = "healer"
#				discord_sdk.small_image_text = "Miriam"
#		#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#		#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#		discord_sdk.refresh() # Always refresh after changing the values!

var temp_details = ""
var temp_state = ""
var temp_large_image = ""
var temp_large_image_text = ""
var temp_small_image = ""
var temp_small_image_text = ""

func saveDiscordRP():
	if globals.discord_enabled:
#		temp_details = discord_sdk.details
#		print("Saving details: ", temp_details)
#		temp_state = discord_sdk.state
#		temp_large_image = discord_sdk.large_image
#		temp_large_image_text = discord_sdk.large_image_text
#		temp_small_image = discord_sdk.small_image
#		temp_small_image_text = discord_sdk.small_image_text
		pass
	
func loadDiscordRP():
	if globals.discord_enabled:
		print("Loading details: ", temp_details)
#		discord_sdk.details = temp_details
#		discord_sdk.state = temp_state
#		discord_sdk.large_image = temp_large_image
#		discord_sdk.large_image_text = temp_large_image_text
#		discord_sdk.small_image = temp_small_image
#		discord_sdk.small_image_text = temp_small_image_text
#		discord_sdk.refresh()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player") and can_interact:
		#print("interacted")
		interacted = true
		interact.visible = true
		
		
func _check_interaction(npc):
	#print(globals.mobs_on_screen)
	if globals.mobs_on_screen < 0:
		globals.mobs_on_screen = 0
	if Input.is_action_just_pressed("interact") and can_interact and globals.mobs_on_screen == 0:
		interact.visible = false
		$interact.play()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		# Available player expressions: Ramis(Player), PlayerShock, PlayerConcern, PlayerLaugh, PlayerApology, PlayerCat
		#Discord Rich Presence
		if globals.discord_enabled:
			saveDiscordRP()
			setDiscordRP(npc)
		#Matching Conversations
		match npc:
			"Isla":
				if globals.death_counter == 1:
					isla_lvl = 1
				elif globals.death_counter == 2:
					isla_lvl = 2
				elif globals.death_counter == 3:
					isla_lvl = 3
				elif globals.death_counter == 4:
					isla_lvl = 4
				if globals.boss_defeated:
					textbox.queue_character("PlayerConcern")
					textbox.queue_text("So, what happened to \"don't expect me to save you again?\"")
					textbox.queue_character("Isla")
					textbox.queue_text("...")
					textbox.queue_character("PlayerLaugh")
					textbox.queue_text("I'm just kidding, don't say anything! Thank you. Truly.")
					textbox.queue_character("PlayerLaugh")
					textbox.queue_text("Your enchanted forest is quite nice, but I'd rather not be stuck there unconscious with Corroded spirits prowling around.")
					textbox.queue_character("Isla")
					textbox.queue_text("...You're welcome. And thank you, too—I don't know where you got that staff, but it seems to have healing magic beyond even my own.")
					textbox.queue_character("Ramis")
					textbox.queue_text("I'm not sure either...but for some reason, I can't help but feel that the staff's gem is connected to the center of the forest somehow.")
					textbox.queue_character("Ramis")
					textbox.queue_text("The Corrosion may be gone for good, but I think I'll stay in Mossglen for the time being to keep the gem close to the forest.")
					textbox.queue_character("Isla")
					textbox.queue_text("That's for the best. I felt the forest breathe easier with the gem nearby too.")
					textbox.queue_character("Ramis")
					textbox.queue_text("Yes! All's well that ends well.")
				elif not globals.has_died:
					textbox.queue_character("Isla")
					textbox.queue_text("What is a human like you doing in our forest?")
					textbox.queue_character("PlayerApology")
					textbox.queue_text("Sorry, I hadn't realized I was in the spirit forest already...I was injured by a strange spirit deer all the way back near Mossglen and thought I'd investigate.")
					textbox.queue_character("Isla")
					textbox.queue_text("Serves you right. No human should be meddling in our matters.")
					textbox.queue_character("PlayerConcern")
					textbox.queue_text("What do you have against humans, anyway?")
					textbox.queue_character("Isla")
					textbox.queue_text("Who do you think caused the Corrosion in the first place?")
					textbox.queue_character("PlayerConcern")
					textbox.queue_text("No...the villagers of Mossglen are kind. They're affected by the Corrosion too—they wouldn't have.")
					textbox.queue_character("Isla")
					textbox.queue_text("Not them, but the ones who came before. And now, I'm left to clean their messes before it rots the forest from the inside out.")
					textbox.queue_character("PlayerApology")
					textbox.queue_text("Oh...I didn't realize. I promise I'm here to help, though.")
					textbox.queue_character("Isla")
					textbox.queue_text("...That's exactly what those humans from long ago said, too.")
				elif isla_lvl == 4 and globals.death_counter >= 4:
					textbox.queue_character("Isla")
					textbox.queue_text("Oh, hello. The deers told me they've been feeling much better.")
					textbox.queue_character("Ramis")
					textbox.queue_text("Of course! Now just to heal the bears, too.")
					if globals.death_counter >= 4:
						isla_lvl = randi_range(1,4)
				elif isla_lvl == 3 and globals.death_counter >= 3:
					textbox.queue_character("Isla")
					textbox.queue_text("So stubborn. At least you're making some progress.")
					textbox.queue_character("PlayerLaugh")
					textbox.queue_text("Just trying to help! That's a compliment coming from you.")
					textbox.queue_character("Isla")
					textbox.queue_text("...")
					if globals.death_counter >= 4:
						isla_lvl = randi_range(1,4)
				elif isla_lvl == 2 and globals.death_counter >= 2:
					textbox.queue_character("Isla")
					textbox.queue_text("For a human, you're not causing as much damage to the forest as I'd expect.")
					textbox.queue_character("PlayerConcern")
					textbox.queue_text("Damage? I'm healing the Corrosion.")
					textbox.queue_character("Isla")
					textbox.queue_text("Whatever. Just stay out of my way.")
					if globals.death_counter >= 3:
						isla_lvl = randi_range(1,3)
				elif globals.death_counter >= 1:
					textbox.queue_character("Isla")
					textbox.queue_text("Still here? Even after you passed out and I had to drag your sorry self back to the village?")
					textbox.queue_character("PlayerShock")
					textbox.queue_text("You what?? Well. Um. Thanks? I'll be going now.")
					textbox.queue_character("Isla")
					textbox.queue_text("Hmph. Don't expect me to be so kind if you succumb to the Corrosion again.")
					if globals.death_counter >= 2:
						isla_lvl = randi_range(1,2)

			"Ilya":
				if globals.boss_defeated:
					textbox.queue_character("Shopkeep")
					textbox.queue_text("Well, I never! You did it, lad!")
					textbox.queue_character("PlayerLaugh")
					textbox.queue_text("I can't believe it either! Oh, I'm so relieved.")
					textbox.queue_character("Shopkeep")
					textbox.queue_text("Us as well—Mossglen owes its continued existence to you.")
					textbox.queue_character("PlayerShock")
					textbox.queue_text("Nononono haha please, I'm just happy to help!")
				elif not globals.has_died:
					textbox.queue_character("Shopkeep")
					textbox.queue_text("Hah, so you're the newest lad that our Healer recruited to cleanse the forest, eh?")
					textbox.queue_character("Ramis")
					textbox.queue_text("That's me now, I guess!")
					textbox.queue_character("Shopkeep")
					textbox.queue_text("Between you and me, I'd turn around. Mossglen's already done for--don't risk your life for this.")
					textbox.queue_character("PlayerConcern")
					textbox.queue_text("Healer's already been so generous. I promised I'd help.")
					ilya_lvl = 1
				elif ilya_lvl == 1 and globals.death_counter >= 1:
					textbox.queue_character("Shopkeep")
					textbox.queue_text("Back already? You're a resilient one, aren't ya.")
					textbox.queue_character("PlayerLaugh")
					textbox.queue_text("It makes me happy seeing the forest so pretty and the spirits free from Corrosion.")
					ilya_lvl = randi_range(1,3)
				elif ilya_lvl == 2 and globals.death_counter >= 1:
					textbox.queue_character("Shopkeep")
					textbox.queue_text("Good luck out there!")
					textbox.queue_character("Ramis")
					textbox.queue_text("Thank you!")
					ilya_lvl = randi_range(1,3)
				elif globals.death_counter >= 1:
					textbox.queue_character("Shopkeep")
					textbox.queue_text("We really appreciate you helping us, lad, but your health comes first.")
					textbox.queue_character("PlayerConcern")
					textbox.queue_text("I don't know why, but it feels like this is what I'm meant to do.")
					ilya_lvl = randi_range(1,3)
			"Iliea":
				if globals.boss_defeated:
					textbox.queue_character("Healer")
					textbox.queue_text("Ramis, you came back by yourself! Does that mean...?")
					textbox.queue_character("Ramis")
					textbox.queue_text("Yes, I think so—the Corrosion's gone for good!")
					textbox.queue_character("PlayerShock")
					textbox.queue_text("Wait. What do you mean \"by myself\"?? How else?")
					textbox.queue_character("Healer")
					textbox.queue_text("Um...Isla over there usually drags you back to Mossglen rather unceremoniously.")
					textbox.queue_character("PlayerShock")
					textbox.queue_text("...")
				elif not globals.has_died:
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
					iliea_lvl = 1
				elif iliea_lvl == 1 and globals.death_counter >= 1:
					textbox.queue_character("Healer")
					textbox.queue_text("You're back! How'd it go?")
					textbox.queue_character("PlayerApology")
					textbox.queue_text("Well...I healed some forest spirits, but didn't make it all the way.")
					textbox.queue_character("Healer")
					textbox.queue_text("That's great to hear! Any progress is good.")
					iliea_lvl = randi_range(1,3)
				elif iliea_lvl == 2 and globals.death_counter >= 1:
					textbox.queue_character("Healer")
					textbox.queue_text("Feeling better?")
					textbox.queue_character("Ramis")
					textbox.queue_text("Much better. Thank you!")
					iliea_lvl = randi_range(1,3)
				elif globals.death_counter >= 1:
					textbox.queue_character("PlayerLaugh")
					textbox.queue_text("Oops, took a bit of a spill there.")
					textbox.queue_character("Healer")
					textbox.queue_text("A spill is quite the understatement. Glad to see you back on your feet, though!")
					iliea_lvl = randi_range(1,3)
				
		can_interact = false
		
		
	if globals.textbox_finished:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		globals.textbox_finished = false
		can_interact = true
		if $Icon.visible:
			$Icon.visible = false
		interact.visible = true
		if globals.discord_enabled:
			loadDiscordRP()


func _on_hitbox_body_exited(body):
	if body.is_in_group("player"):
		#print("interacted")
		interacted = false
		can_interact = true
		interact.visible = false
