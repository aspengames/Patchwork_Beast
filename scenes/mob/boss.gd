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

#Navigation
var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2.ZERO
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready():
	atkTimer = $atkTimer
	$anim.play("bossmob_idle")
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
		if not charge_bar:
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
		if not trulydead:
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
			
			if not $anim.is_playing():
				$anim.play()
		else:
			$anim.stop()
			
		if health < 1 and alive:
			globals.mobs_on_screen -= 1
			alive = false
			$deadanim.play("dead")
			$col.disabled = true
			
		if trulydead and $pars.emitting == false: # pars is the player's particles?
			$deathTimer.start()
			

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
			startpos = Vector2(300,10)
		else:
			startpos = Vector2(-300,10)
			#print("NOPE")
		print("called")
		var nift_direction = nift_dir
		var nift = NIFT.instantiate()
		get_tree().current_scene.get_node("Player/projectiles").add_child(nift)
		nift.global_position = self.global_position + startpos#self.global_positions
		#nift.z_index = -1
		var nift_rotation = nift_direction.angle()
		if -PI/4 < nift_rotation:
			if nift_rotation < PI/4:
				pass
				#nift.global_position = $Staff1.global_position
		if PI/4 < nift_rotation:
			if nift_rotation < 3*PI/4:
				pass
				#nift.global_position = $Staff1.global_position
		if -PI < nift_rotation:
			if nift_rotation < -3*PI/4:
				pass
				#nift.global_position = $Staff2.global_position
		if 3*PI/4 < nift_rotation:
			if nift_rotation < PI:
				pass
				#nift.global_position = $Staff2.global_position
		if -3*PI/4 < nift_rotation:
			if nift_rotation < -PI/4:
				pass
				#nift.global_position = $Staff2.global_position
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
	trulydead = true

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
	var rand_hurt = (randi() % 8) + 2 #4-9
	player.get_node("ui/boss_health").value -= rand_hurt
	if player.get_node("ui/boss_health").value <= 0:
		#Super Janky not animated or clean - getting rid of boss + boss healthbar ASAP
		call_deferred("queue_free")
		player.get_node("ui/boss_health").visible = false
		textbox.queue_character("PlayerApology")
		textbox.queue_text("Whew...")
		textbox.queue_character("Ramis")
		textbox.queue_text("I think I've stopped the source of the corrosion.")

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
