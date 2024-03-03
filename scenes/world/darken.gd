extends Area2D

@onready var player = $"../../NAV/Map/Map/Player"
@onready var darklyr = $"../../Night"

@export var vertical = true
@export var upright = true
@export var percent_to_dark = 0.1

#For Discord RPC
@onready var boss = $"../../NAV/Map/Map/patchworkbeast"

#H,S,V
var base_color = [0.61202210187912,0.59803873300552,0.80000001192093]
var cur_color_s
var cur_color_v
var cur_color_h
var cur_color
var new_color

var extent_y
var extent_x

var left_bound
var right_bound
var up_bound
var down_bound

var total_y

var onetime = true
var darkening = false

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_color_h = darklyr.color.h
	cur_color_s = darklyr.color.s
	cur_color_v = darklyr.color.v
	cur_color = darklyr.color
	new_color = Color.from_hsv(0.61202210187912,0.59803873300552,0.80000001192093, 1.0)
	#print(cur_color_h)
	#print(cur_color_s)
	#print(cur_color_v)
	extent_y = $col.scale.y * 10
	extent_x = $col.scale.x * 10
	left_bound = self.global_position.x - extent_x
	right_bound = self.global_position.x + extent_x
	up_bound = self.global_position.y - extent_y
	down_bound = self.global_position.y + extent_y
	
	total_y = down_bound - up_bound
	#print("total y is ", total_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if darkening:
		#print(self.global_position)
		#print(player.global_position)
		#print("darklyr is", darklyr)
		if vertical:
			if player.global_position.y < down_bound and up_bound < player.global_position.y and onetime:
				onetime = false
				
				var player_dist_from_bottom = abs(player.global_position.y - down_bound)
				#print(player_dist_from_bottom)
				var player_walked_perc = player_dist_from_bottom / total_y
				#print(player_walked_perc)
				if not upright:
					player_walked_perc = 1 - player_walked_perc
				
				var partial_color = Color.from_hsv(0.61202210187912, percent_to_dark * 0.59803873300552, (((1 - player_walked_perc) * 0.2) + 0.80000001192093), 1.0)
				#print("A", partial_color)
				
				#Don't do anything if color is lighter than current
				var night_color = darklyr.color
				#print(night_color.h, night_color.s, night_color.v, "NIGHT")
				if night_color.h > partial_color.h:
					#print("No action")
					return
				if night_color.s > partial_color.s:
					#print("No action")
					return
				
				var tween1 = create_tween()
				tween1.connect("finished", reset)
				tween1.tween_property(darklyr, "color", partial_color, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT) 
		else:
			if player.global_position.x > left_bound and right_bound > player.global_position.x and onetime:
				onetime = false
				
				var player_dist_from_left = abs(player.global_position.x - left_bound)
				#print(player_dist_from_bottom)
				var player_walked_perc = player_dist_from_left / total_y
				#print(player_walked_perc)
				
				if not upright:
					player_walked_perc = 1 - player_walked_perc
				
				var partial_color = Color.from_hsv(0.61202210187912, percent_to_dark * 0.59803873300552, (((1 - player_walked_perc) * 0.2) + 0.80000001192093), 1.0)
				#print(partial_color)
				
				#Don't do anything if color is lighter than current
				var night_color = darklyr.color
				#print(night_color.h, night_color.s, night_color.v, "NIGHT")
				if night_color.h > partial_color.h:
					#print("No action")
					return
				if night_color.s > partial_color.s:
					#print("No action")
					return
				
				var tween1 = create_tween()
				tween1.connect("finished", reset)
				tween1.tween_property(darklyr, "color", partial_color, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT) 
func reset():
	onetime = true

func _on_darken_body_entered(body):
	if body.is_in_group("player"):
		darkening = true
		
		#DISCORD RICH PRESENCE
		if globals.discord_enabled:
			print("SELF NAME IS:", self.name)
#			if self.name == "darken":
#				if globals.discord_enabled:
#					print("UPDATED DISCORD RP")
#					discord_sdk.details = "Exploring the Forest"
#					discord_sdk.state = ""
#					discord_sdk.large_image = "forest"
#					discord_sdk.large_image_text = "Forest"
#					discord_sdk.small_image = ""
#					discord_sdk.small_image_text = ""
#				#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#				#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#					discord_sdk.refresh() # Always refresh after changing the values!
#			if self.name == "darken2":
#				if globals.discord_enabled:
#					print("UPDATED DISCORD RP")
#					discord_sdk.details = "Battling spirit deer"
#					discord_sdk.state = ""
#					discord_sdk.large_image = "forest"
#					discord_sdk.large_image_text = "Forest"
#					discord_sdk.small_image = ""
#					discord_sdk.small_image_text = ""
#					#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#					#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#					discord_sdk.refresh() # Always refresh after changing the values!
#			if self.name == "darken3":
#				if globals.discord_enabled:
#					print("UPDATED DISCORD RP")
#					discord_sdk.details = "Exploring depths of the Forest"
#					discord_sdk.state = ""
#					discord_sdk.large_image = "forest"
#					discord_sdk.large_image_text = "Forest"
#					discord_sdk.small_image = ""
#					discord_sdk.small_image_text = ""
#					#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#					#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#					discord_sdk.refresh() # Always refresh after changing the values!
#			if self.name == "darken5":
#				if globals.discord_enabled:
#					print("UPDATED DISCORD RP")
#					discord_sdk.details = "Adventuring deep in the Forest"
#					discord_sdk.state = ""
#					discord_sdk.large_image = "forest2"
#					discord_sdk.large_image_text = "Forest"
#					discord_sdk.small_image = ""
#					discord_sdk.small_image_text = ""
#					#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#					#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#					discord_sdk.refresh() # Always refresh after changing the values!
#			if self.name == "darken6":
#				print("UPDATED DISCORD RP")
#				discord_sdk.details = "Battling spirit bears"
#				discord_sdk.state = ""
#				discord_sdk.large_image = "forest2"
#				discord_sdk.large_image_text = "Forest"
#				discord_sdk.small_image = ""
#				discord_sdk.small_image_text = ""
#				#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#				#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#				discord_sdk.refresh() # Always refresh after changing the values!
#			if self.name == "darken8" and not boss.activated:
#				print("UPDATED DISCORD RP")
#				discord_sdk.details = "Braving the innermost Forest"
#				discord_sdk.state = ""
#				discord_sdk.large_image = "forest3"
#				discord_sdk.large_image_text = "Forest"
#				discord_sdk.small_image = ""
#				discord_sdk.small_image_text = ""
#				#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#				#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#				discord_sdk.refresh() # Always refresh after changing the values!
#			if self.name == "darken8" and boss.activated:
#				print("UPDATED DISCORD RP")
#				discord_sdk.details = "Wandering through Healed Forest"
#				discord_sdk.state = ""
#				discord_sdk.large_image = "heal1"
#				discord_sdk.large_image_text = "Forest"
#				discord_sdk.small_image = ""
#				discord_sdk.small_image_text = ""
#				#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#				#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#				discord_sdk.refresh() # Always refresh after changing the values!
#			if self.name == "darken5" and boss.activated:
#				print("UPDATED DISCORD RP")
#				discord_sdk.details = "Wandering through Healed Forest"
#				discord_sdk.state = ""
#				discord_sdk.large_image = "heal2"
#				discord_sdk.large_image_text = "Forest"
#				discord_sdk.small_image = ""
#				discord_sdk.small_image_text = ""
#				#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#				#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#				discord_sdk.refresh() # Always refresh after changing the values!
#			if self.name == "darken2" and boss.activated:
#				print("UPDATED DISCORD RP")
#				discord_sdk.details = "Returning to Mossglen"
#				discord_sdk.state = ""
#				discord_sdk.large_image = "heal3"
#				discord_sdk.large_image_text = "Forest"
#				discord_sdk.small_image = ""
#				discord_sdk.small_image_text = ""
#				#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#				#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#				discord_sdk.refresh() # Always refresh after changing the values!
#			if self.name == "darken" and boss.activated:
#				print("UPDATED DISCORD RP")
#				discord_sdk.details = "Finalizing the heroic journey"
#				discord_sdk.state = ""
#				discord_sdk.large_image = "mossglen"
#				discord_sdk.large_image_text = "Mossglen Village"
#				discord_sdk.small_image = ""
#				discord_sdk.small_image_text = ""
#				#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#				#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#				discord_sdk.refresh() # Always refresh after changing the values!
			pass
		
		

func _on_darken_body_exited(body):
	if body.is_in_group("player"):
		darkening = false
