extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@onready var player = $"../Player/Player"
var dist = 999999
var alive = true
var trulydead = false
var attacking = false
var attack_player_dir
var speed = 150
var charge_bar = false
var atk_counter = 3

@export var health = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var player_dir = self.global_position.direction_to(player.global_position)
	#print(player_dir)
	
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
	if (self.global_position.distance_to(player.get_global_position()) < 1000) and not trulydead:
		#self.global_position += player_dir
		#self.move_and_slide(player_dir * 500)
		
		if not $anim.is_playing():
			$anim.play()
		
		if charge_bar:  
			return
			
		if (self.global_position.distance_to(player.get_global_position()) < 400) and not charge_bar and not attacking:
			charge_bar = true
			$anim.play("bearmob_attack")
<<<<<<< Updated upstream
			$Sprite/pars_dirt.emitting = true
			# play attack, emit dirt particles
=======
			$atkRadius/earth_shatter_hitbox.scale = Vector2(40,40)
			atk_counter = 3
			$groundshake.amount = 100
			$groundshake.initial_velocity_min = 500
			$groundshake.initial_velocity_max = 1000
			$groundshake.lifetime = 0.5
>>>>>>> Stashed changes
		
		self.velocity = player_dir * speed
		
		if not charge_bar:
			self.move_and_slide()	
			$Sprite/pars_dirt.emitting = false
		
		if not $anim.is_playing():
			$anim.play()
	else:
		$anim.stop()
		
	if health < 1 and alive:
		alive = false
		$deadanim.play("dead")
		$col.disabled = true
		
	if trulydead and $pars.emitting == false: # pars is the player's particles?
		$deathTimer.start()
		

#func _init(enemy, params):
#  enemy.dir = (enemy.target.position - enemy.position).normalized()
#
#func _physics_process(delta):
#  var motion = enemy.dir * enemy.speed
#  enemy.move_and_slide(motion)

func _on_deadanim_animation_finished(_anim_name):
	trulydead = true

func _on_vis_screen_entered():
	globals.mobsight = true
func _on_vis_screen_exited():
	globals.mobsight = false


func _on_deathTimer_timeout():
	queue_free()


func _on_anim_animation_finished(anim_name):
	if anim_name == "bearmob_attack" and $atkCooldown.is_stopped():
		print("ENTER THE MAINFRAME")
		$anim.play("bearmob_idle")
		$atkCooldown.start()
		if $groundshake.emitting:
			$groundshake.emitting = false
		$groundshake.restart()
		$groundshake.emitting = true
		$atkRadius/earth_shatter_hitbox.scale *= 1.5
		if $atkRadius.overlaps_body(player):
			player._on_HITBOX_body_entered($atkRadius)
		atk_counter -= 1
		#Screen Shake
		if atk_counter == 2:
			player.get_node("Camera2D").small_shake()
		elif atk_counter == 1:
			player.get_node("Camera2D").med_shake()
		elif atk_counter == 0:
			player.get_node("Camera2D").large_shake()
		
		if atk_counter <= -1:
			$atkRadius/earth_shatter_hitbox.scale = Vector2(40,40)
			attacking = false
			charge_bar = false
			atk_counter = 3
			$groundshake.amount = 100
			$groundshake.initial_velocity_min = 500
			$groundshake.initial_velocity_max = 1000
			$groundshake.lifetime = 0.5
		
func _on_atk_cooldown_timeout():
	$atkCooldown.stop()
	if atk_counter > 0:
		$anim.play('bearmob_attack')
	else:
		$anim.play('bearmob_idle')
		#Reset
		$atkRadius/earth_shatter_hitbox.scale = Vector2(40,40)
		attacking = false
		charge_bar = false
		atk_counter = 3
		$groundshake.amount = 100
		$groundshake.initial_velocity_min = 500
		$groundshake.initial_velocity_max = 1000
		$groundshake.lifetime = 0.5
	#GroundShake update
	$groundshake.amount *= 2
	$groundshake.initial_velocity_min *= 1.5
	$groundshake.initial_velocity_max *= 1.5
	$groundshake.lifetime *= 2