extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@onready var player = $"../Player"
@onready var textbox = $"../Player/Camera2D/Textbox"
var dist = 999999
var alive = true
var trulydead = false
var attacking = false
var attack_player_dir
var speed = 150
var charge_bar = false
var atk_counter = 3
var player_rad = false

var activated = false

var scuttle = false
@export var health = 9999
var NIFT: PackedScene = preload("res://projectiles/BossNift.tscn")
var nift_dir

var atkTimer
var wait_for_textbox = false
#var end_uncorrupt = false
#Navigation
var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2.ZERO
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var gearblock = $"../../../../NAV/Map/Map/biggear"
@onready var bossfight = $"../../../../Boss"
@onready var forestdarken = $"../../../../ForestDarken"
@onready var treecorrupt = $"../../../../TreeCorrupt"
@onready var tilemap = $"../../../../NAV/Map/Map"
@onready var npc1 = $"../../../../NAV/Map/Map/Iliea"
@onready var npc2 = $"../../../../NAV/Map/Map/Isla"
@onready var npc3 = $"../../../../NAV/Map/Map/Ilya"
@onready var spiritpos = $"../../../../HealedSpiritsPos"
@onready var credits = $"../../../../Credits"

var gearSFX1 = preload("res://music/gearSFX1.wav")
var gearSFX2 = preload("res://music/gearSFX2.wav")
var deathSFX = preload("res://music/clatter.mp3")
var eyesSFX = preload("res://music/kachunk.mp3")

var mob_deer = preload("res://scenes/mob/mob.tscn")
var mob_bear = preload("res://scenes/mob/bearmob.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#forestdarken.queue_free()
	atkTimer = $atkTimer
	$anim.play("bossmob_idle")
	#player_rad = true
	#activated = true
	#player.get_node("ui/boss_health").value = 0
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_rad and activated:
#		if (self.global_position.distance_to(player.get_global_position()) < 1000):
#			autocorrode()
		var player_dir = self.global_position.direction_to(player.global_position)
		#print(player_dir)
		attack_player_dir = self.global_position.direction_to(player.global_position)
		var mob_rot = player_dir.angle()
		#print(mob_rot)
		#print(mob_rot)
		#print(mob_rot)
		#print(PI)
		if not charge_bar and player.get_node("ui/boss_health").value > 0:
			if -PI/4 < mob_rot:
				if mob_rot < PI/4:
					$anim.play("mob_right")
			if PI/4 < mob_rot:
				if mob_rot < 3*PI/4:
					$anim.play("mob_down")
			if -PI < mob_rot:
				if mob_rot < -3*PI/4:
					$anim.play("mob_left")
			if 3*PI/4 < mob_rot:
				if mob_rot < PI:
					$anim.play("mob_left")
			if -3*PI/4 < mob_rot:
				if mob_rot < -PI/4:
					$anim.play("mob_up")

		#print(globals.mobsight)
		#print(self.global_position.distance_to(player.get_global_position()))
		if not trulydead and player.get_node("ui/boss_health").value > 0:
			#self.global_position += player_dir
			#self.move_and_slide(player_dir * 500)
			
			if not $anim.is_playing():
				$anim.play()
			
			if charge_bar:  
				return
			
			var rand_dist = 500
			if scuttle and attacking and get_slide_collision_count() > 0 and (self.global_position.distance_to(player.get_global_position()) < 300):
				scuttle = false
				attacking = false
				print("scuttled")
				speed = 150
				movement_speed = 200
				player.knockback(3, attack_player_dir)
				player_shake()
			if not scuttle and attacking and (self.global_position.distance_to(player.get_global_position()) < rand_dist):
				attacking = false
				print("Second ATK")
				charge_bar = true
				$anim.play("bossmob_attack1")
			if (self.global_position.distance_to(player.get_global_position()) < 1000) and not charge_bar and not attacking:
				
				
				#Decision Making for the Boss (Randomized Attacks)
				randomize()
				var atk = (randi() % 3) #This is between 0 and 2

				match atk:
					0:
						print("First ATK")
						charge_bar = true
						$anim.play("bossmob_attack_right")
						if -PI/4 < mob_rot:
							if mob_rot < PI/4:
								$anim.play("bossmob_attack_right")
						if -PI < mob_rot:
							if mob_rot < -3*PI/4:
								$anim.play("bossmob_attack_left")
						if 3*PI/4 < mob_rot:
							if mob_rot < PI:
								$anim.play("bossmob_attack_left")
				
						var nift_direction = self.global_position.direction_to(player.get_global_position())
						throw_nift(nift_direction)
						$atkCooldown.start()
					1:
						rand_dist = (randi() % 201) #0 to 200
						rand_dist = 300 + rand_dist
						attacking = true
						#If not within rand_dist, bear will run at player!!! 
						$atkCooldown.start()
					
					2:
						print("Third ATK")
						speed = 500
						movement_speed = 400
						scuttle = true
						attacking = true
						$atkCooldown.start()
						$bossaud.play()
				#$Sprite/pars_dirt.emitting = true
				# play attack, emit dirt particles
#				$atkRadius/earth_shatter_hitbox.scale = Vector2(40,40)
#				atk_counter = 3
#				$groundshake2.amount = 100
#				$groundshake2.process_material.initial_velocity_min = 500
#				$groundshake2.process_material.initial_velocity_max = 1000
#				$groundshake2.lifetime = 0.5
				
			self.velocity = player_dir * speed
			
			if not charge_bar:
				#New Navigation Movement
				var movement_target_position = player.get_global_position()
				set_movement_target(movement_target_position)
				var current_agent_position: Vector2 = global_transform.origin
				var next_path_position: Vector2 = navigation_agent.get_next_path_position()
				var new_velocity: Vector2 = next_path_position - current_agent_position
				new_velocity = new_velocity.normalized()
				new_velocity = new_velocity * movement_speed
				velocity = new_velocity
				self.move_and_slide()	
				#$Sprite/pars_dirt.emitting = false
				if velocity > Vector2.ZERO and not $bossaud.playing:
					var randint = randi_range(1,2)
					match randint:
						1:
							$bossaud.stream = gearSFX1
						2:
							$bossaud.stream = gearSFX2
					#print(randint)
					$bossaud.play()
			
			if not $anim.is_playing():
				$anim.play()
		elif player.get_node("ui/boss_health").value > 0:
			$anim.stop()
			
		if player.get_node("ui/boss_health").value < 1 and alive:
			globals.mobs_on_screen -= 1
			alive = false
			globals.boss_defeated = true
			print("boss dead anim")
			$anim.stop()
			$anim.play("bossmob_death")
			$bossaud.stop()
			player.get_node("ui/boss_health").visible = false
			player.get_node("ui/health").visible = false
			textbox.healthvis = false
			$col.disabled = true
			
			npc1.get_node("Icon").visible = true
			npc2.get_node("Icon").visible = true
			npc3.get_node("Icon").visible = true
			
			$bossaud.stream = deathSFX
			$bossaud.play()
			
			var tween1 = create_tween()
			tween1.tween_property(AudioController.get_node("MainBGM"), "volume_db", -80, 5.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
#			
		#if trulydead: # and $pars.emitting == false: # pars is the player's particles?
			#$deathTimer.start()
			
	if wait_for_textbox:
		if textbox.all_finished:
			wait_for_textbox = false
	
			
			await get_tree().create_timer(5).timeout
			
			#treecorrupt.get_node("corrupt4").animate_uncorrupt()
			#treecorrupt.get_node("corrupt8").animate_uncorrupt()
			#treecorrupt.get_node("corrupt9").animate_uncorrupt()
			AudioController.get_node("MainBGM").volume_db = -17.903
			AudioController.play_credits()
			#end_uncorrupt = true
			$col.disabled = true
			
			bossfight.get_node("anim").play("healnight")
#			if forestdarken:
			forestdarken.queue_free()
			
			npc1.iliea_lvl = 1
			npc2.isla_lvl = 1
			npc3.ilya_lvl = 1
			
			await get_tree().create_timer(3).timeout
			for i in range(10):
				if i == 0:
					continue
				if i == 1:
					treecorrupt.get_node("corrupt").animate_uncorrupt()
					continue
				treecorrupt.get_node(str("corrupt" + str(i))).animate_uncorrupt()
		
			credits.get_node("1/col").disabled = false
			credits.get_node("2/col").disabled = false
			

			
			#var tween1 = create_tween()
			#tween1.tween_property(tilemap.set_layer_modulate, "shader_parameter/cutoff_two", curcor+0.0001, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
#			tilemap.set_layer_y_sort_enabled(1, false)
#			tilemap.set_layer_y_sort_enabled(6, true)
#			tilemap.set_layer_z_index(1, 0)
#			tilemap.set_layer_z_index(6, 0)
#
#			for i in range(100):
#				await get_tree().create_timer(0.01).timeout
#				tilemap.set_layer_modulate(1, Color(255,255,255, 1 - (i * 0.01)))
#				tilemap.set_layer_modulate(6, Color(255,255,255, i * 0.01))
			
#	if end_uncorrupt:
#		await get_tree().create_timer(2).timeout
#		for i in range(10):
#			if i == 0:
#				continue
#			if i == 1:
#				treecorrupt.get_node("corrupt").animate_uncorrupt()
#				continue
#			treecorrupt.get_node(str("corrupt" + str(i))).animate_uncorrupt()
			

func throw_nift(nift_direction: Vector2):
	print("throw nift called")
	if NIFT:
		#$AnimationTree.get("parameters/playback").travel("Shoot")
		#$AnimationTree.set("parameters/Shoot/blend_position", nift_direction)
		nift_dir = nift_direction
		
func actual_throw_nift():
		var startpos = Vector2.ZERO
		if $anim.current_animation == "bossmob_attack_right":
			#print("Heck yeah!") 
			startpos = Vector2(300,-220)
		else:
			startpos = Vector2(-300,-220)
			#print("NOPE")
		print("called")
		var nift_direction = nift_dir
		var nift = NIFT.instantiate()
		get_tree().current_scene.get_node("Player/projectiles").add_child(nift)
		nift.global_position = self.global_position + startpos#self.global_positions
		#nift.z_index = -1
		var nift_rotation = nift_direction.angle()
	
		nift.rotation = nift_rotation
		#$"../laserbgm".play()
		atkTimer.start()
		#print("Started Atk Timer")
		nift.get_node("pars").emitting = true


#func _init(enemy, params):
#  enemy.dir = (enemy.target.position - enemy.position).normalized()
#
#func _physics_process(delta):
#  var motion = enemy.dir * enemy.speed
#  enemy.move_and_slide(motion)
#func autocorrode():
#	#if curcor >= 0.025 and curcor < 0.9:
#		#print(curcor)
#		var tween1 = create_tween()
#		tween1.tween_property($Sprite/corrode.material, "shader_parameter/cutoff_two", curcor+0.0001, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
#		curcor += 0.0001 * 6

#@export var curcor = 0.165
#var damp = 0.5
#func hurt():
#	if curcor < 0.05:
#		damp = 1
#	#This function gets called when the player hits the mob
#	#$Sprite/corrode.material.set("shader_parameter/cutoff_two", 0.05)
#	var tween1 = create_tween()
#	curcor = curcor - ($Sprite/corrode.material.get("shader_parameter/cutoff_two") * damp)
#	tween1.tween_property($Sprite/corrode.material, "shader_parameter/cutoff_two", curcor, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT) 
#	if ($Sprite/corrode.material.get("shader_parameter/cutoff_two") < 0.025):
#		health = 0
#	pass


func _on_deadanim_animation_finished(_anim_name):
	if player in $col_death_static/playerin.get_overlapping_bodies():
		player.knockback(2, attack_player_dir)
	trulydead = true
	if player.get_node("ui/boss_health").value <= 0 and trulydead:
		if globals.discord_enabled:
			#DISCORD RICH PRESENCE
			pass
#			print("UPDATED DISCORD RP")
#			discord_sdk.details = "Triumphing over the Beast"
#			discord_sdk.state = ""
#			discord_sdk.large_image = "heal1"
#			discord_sdk.large_image_text = "Forest"
#			discord_sdk.small_image = ""
#			discord_sdk.small_image_text = ""
#			#discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
#			#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"
#			discord_sdk.refresh() # Always refresh after changing the values!
		
		await get_tree().create_timer(5).timeout
		#Super Janky not animated or clean - getting rid of boss + boss healthbar ASAP
		#call_deferred("queue_free")
		textbox.queue_character("PlayerApology")
		textbox.queue_text("Hah...is it over?")
		textbox.queue_character("PlayerConcern")
		textbox.queue_text("That thing was so scary...that patchwork of spirit parts turned metal...I see now why Isla said the Corrosion was man-made.")
		textbox.queue_character("Ramis")
		textbox.queue_text("Oh, the forest is already starting to feel serene again! It's over, then. What a relief. I'd better head back to Mossglen!")
		
		
		gearblock.get_node("col/col").disabled = true
		gearblock.visible = false
		gearblock.queue_free()
		
		bossfight.get_node("anim").play("boss_defeat")
		#forestdarken.queue_free()
		
		wait_for_textbox = true
		
#		for deerpos in spiritpos.get_node("deer").get_children():
#			var deer = mob_deer.instantiate()
#			get_tree().current_scene.get_node("NAV/Map/Map").add_child(deer)
#			deer.global_position = deerpos.global_position
#			deer.wandering = true
#			deer.scale = Vector2(0.3,0.3)
#
#		for bearpos in spiritpos.get_node("bear").get_children():
#			var bear = mob_bear.instantiate()
#			get_tree().current_scene.get_node("NAV/Map/Map").add_child(bear)
#			bear.global_position = bearpos.global_position
#			bear.wandering = true
#			bear.scale = Vector2(0.4,0.4)
		
		
		await get_tree().create_timer(1).timeout
		tilemap.set_layer_enabled(1, false)#layer_1.enabled = false
		tilemap.set_layer_enabled(6, true)#layer_6.enabled = true
		
		


func _on_vis_screen_entered():
	globals.mobs_on_screen += 1
func _on_vis_screen_exited():
	globals.mobs_on_screen -= 1


func _on_deathTimer_timeout():
	queue_free()

func _on_anim_animation_finished(anim_name):
	if (anim_name == "bossmob_attack_right" or anim_name == "bossmob_attack_left" or anim_name == "bossmob_attack1") and $atkCooldown.is_stopped():
		$anim.play("bearmob_idle")
		$atkCooldown.start()
		
		#print("emitting")
		if anim_name == "bossmob_attack1":
			player.get_node("Camera2D").large_shake()
			player.knockback(1, attack_player_dir)
	#Screen Shake
		player.get_node("Camera2D").small_shake()
		#player.knockback(1, attack_player_dir)
		
		attacking = false
		charge_bar = false
			
		if $atkRadius.overlaps_body(player):
			player._on_HITBOX_body_entered($atkRadius)
#		$groundshake2.process_material.amount = 100
#		$groundshake2.process_material.initial_velocity_min = 500
#		$groundshake2.process_material.initial_velocity_max = 1000
#		$groundshake2.process_material.lifetime = 0.5

#Boss Health
func hurt():
	randomize()
	#var rand_hurt = (randi() % 8) + 2 #2-9
	var rand_hurt = (randi() % 4) + 2 #2-5
	player.get_node("ui/boss_health").value -= rand_hurt
	print("boss has been hurt")

		
func _on_atk_cooldown_timeout():
	$atkCooldown.stop()
	#Reset
	attacking = false
	charge_bar = false


func _on_mobsight_body_entered(body):
	if body.is_in_group("player"):
		player_rad = true
		$mobsight/vis.scale *= 1.5
		#print($mobsight/vis.scale)

func _on_mobsight_body_exited(body):
	if body.is_in_group("player"):
		player_rad = false
		$mobsight/vis.scale /= 1.5
		#print($mobsight/vis.scale)
		attacking = false
		$anim.stop()

func set_movement_target(movement_target: Vector2):
	#print("Setting")
	navigation_agent.target_position = movement_target
	
func player_shake():
	player.get_node("Camera2D").large_shake()
	
func knock_player():
	player.knockback(3, attack_player_dir)
	
func eyes_sfx():
	$bossaud.stream = eyesSFX
	$bossaud.play()
