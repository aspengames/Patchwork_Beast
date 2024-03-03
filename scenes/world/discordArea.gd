extends Area2D

#For Discord RPC
@onready var boss = $"../../NAV/Map/Map/patchworkbeast"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_darken_body_entered(body):
	if body.is_in_group("player"):
		pass
#
#		#DISCORD RICH PRESENCE
#		if self.name == "darken8" and boss.activated:
#			print("UPDATED DISCORD RP")
#			discord_sdk.details = "Wandering through Healed Forest"
#			discord_sdk.state = ""
#			discord_sdk.large_image = "heal1"
#			discord_sdk.large_image_text = "Forest"
#			discord_sdk.small_image = ""
#			discord_sdk.small_image_text = ""
#			#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#			#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#			discord_sdk.refresh() # Always refresh after changing the values!
#		if self.name == "darken5" and boss.activated:
#			print("UPDATED DISCORD RP")
#			discord_sdk.details = "Wandering through Healed Forest"
#			discord_sdk.state = ""
#			discord_sdk.large_image = "heal2"
#			discord_sdk.large_image_text = "Forest"
#			discord_sdk.small_image = ""
#			discord_sdk.small_image_text = ""
#			#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#			#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#			discord_sdk.refresh() # Always refresh after changing the values!
#		if self.name == "darken2" and boss.activated:
#			print("UPDATED DISCORD RP")
#			discord_sdk.details = "Returning to Mossglen"
#			discord_sdk.state = ""
#			discord_sdk.large_image = "heal3"
#			discord_sdk.large_image_text = "Forest"
#			discord_sdk.small_image = ""
#			discord_sdk.small_image_text = ""
#			#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#			#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#			discord_sdk.refresh() # Always refresh after changing the values!
#		if self.name == "darken" and boss.activated:
#			print("UPDATED DISCORD RP")
#			discord_sdk.details = "Finalizing the heroic journey"
#			discord_sdk.state = ""
#			discord_sdk.large_image = "mossglen"
#			discord_sdk.large_image_text = "Mossglen Village"
#			discord_sdk.small_image = ""
#			discord_sdk.small_image_text = ""
#			#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#			#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#			discord_sdk.refresh() # Always refresh after changing the values!
#
#
		

func _on_darken_body_exited(body):
	if body.is_in_group("player"):
		pass
