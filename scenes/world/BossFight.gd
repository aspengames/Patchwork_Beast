extends Area2D

@onready var player = $"../NAV/Map/Map/Player"
@onready var textbox = $"../NAV/Map/Map/Player/Camera2D/Textbox"
@onready var boss = $"../NAV/Map/Map/patchworkbeast"
@onready var gearblock = $"../NAV/Map/Map/biggear"
var one = false
var two = false
var prev = 9999
# Called when the node enters the scene tree for the first time.
func _ready():
	boss.get_node("anim").connect("animation_finished", _on_BOSS_finished)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if globals.conv_amnt_comp > prev and one and not two:
		two = true
		boss.get_node("anim").play("bossmob_activate")
		

func _on_Boss_start(body):
	if body.is_in_group("player") and not one:
		globals.player_stop = true
		$anim.play("camera_shift_boss")
		if globals.discord_enabled:
			#DISCORD RICH PRESENCE
			print("UPDATED DISCORD RP")
#			discord_sdk.details = "Fighting the Beast"
#			discord_sdk.state = ""
#			discord_sdk.large_image = "boss"
#			discord_sdk.large_image_text = "They will not survive."
#			discord_sdk.small_image = ""
#			discord_sdk.small_image_text = ""
#			#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#			#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#			discord_sdk.refresh() # Always refresh after changing the values!
		
func _on_ANIM_finished(anim_name):
	if anim_name == "camera_shift_boss" and not one:
		#setting gear blocker
		gearblock.visible = true
		gearblock.get_node("col/col").disabled = false
		one = true
		prev = globals.conv_amnt_comp + 1
		textbox.queue_character("PlayerApology")
		textbox.queue_text("What is that thing? It looks like a monster made from rusty metal. Could it be the source of the corrosion?")
		textbox.queue_character("PlayerShock")
		textbox.queue_text("...!")
		textbox.unfreeze = false
		#globals.player_stop = true
	if anim_name == "camera_shift_boss" and two:
		globals.player_stop = false
		player.get_node("ui/boss_health").visible = true
		boss.activated = true
		AudioController.play_boss()
		boss.get_node("bossaud").stream = boss.gearSFX1
	
func _on_BOSS_finished(anim_name):
	if anim_name == "bossmob_activate":
		$anim.play_backwards("camera_shift_boss")
