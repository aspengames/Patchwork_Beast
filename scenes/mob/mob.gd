extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@onready var player = $"../Player"
var dist = 999999
var alive = true
var trulydead = false
var buck = false
var attacking = false
var attack_player_dir
var speed = 250
var player_rad = false

signal deers_healed

@export var health = 9999
@export var sleeping = false
#Navigation
var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2.ZERO
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#Navigation actor setup
	call_deferred("actor_setup")
	if sleeping:
		$anim.play("sleep")
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)
	
func set_movement_target(movement_target: Vector2):
	#print("Setting")
	navigation_agent.target_position = movement_target
	
var move_to_player = false
func _physics_process(delta):
	if sleeping:
		return
	if move_to_player:
		move_to_player = false
		movement_target_position = player.get_global_position()
		set_movement_target(movement_target_position)
		var current_agent_position: Vector2 = global_transform.origin
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		var new_velocity: Vector2 = next_path_position - current_agent_position
		new_velocity = new_velocity.normalized()
		new_velocity = new_velocity * movement_speed
		#print("new velocity is", new_velocity)
		velocity = new_velocity
		move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sleeping:
		return
	if player_rad:
		#print("Processor called")
		if (self.global_position.distance_to(player.get_global_position()) < 1000):
			autocorrode()
		var player_dir = self.global_position.direction_to(player.global_position)
		#print(player_dir)
		
		var mob_rot = player_dir.angle()
		#print(mob_rot)
		#print(mob_rot)
		#print(mob_rot)
		#print(PI)
		if not buck:
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
			if not $anim.is_playing():
				$anim.play()
			if buck:
				return
			#self.global_position += player_dir
			#self.move_and_slide(player_dir * 500)
			if (self.global_position.distance_to(player.get_global_position()) < 500) and not buck and not attacking:
				buck = true
				
				$atkTimer.start()
				if -PI/2 < mob_rot:
					if mob_rot < PI/2:
						$anim.play("mob_attack_right")
				if -PI/2 > mob_rot:
					$anim.play("mob_attack_left")
				if PI/2 < mob_rot: 
					$anim.play("mob_attack_left")
					
			if not buck:
				self.velocity = player_dir * speed
				
			if attacking:
				self.velocity = attack_player_dir * speed
				speed += 5
			
			move_to_player = true
			self.move_and_slide()	
			
			if not $anim.is_playing():
				$anim.play()
		else:
			$anim.stop()
			
		if health < 1 and alive:
			globals.mobs_on_screen -= 1
			alive = false
			$deadanim.play("dead")
			$col.disabled = true
			globals.deers -= 1
			if globals.deers <= 0:
				emit_signal("deers_healed")
				print("Emitted signal deers healed")
			
		if trulydead and $pars.emitting == false:
			$deathTimer.start()
		
		
func autocorrode():
	if curcor >= 0.025 and curcor < 0.9:
		#print(curcor)
		var tween1 = create_tween()
		tween1.tween_property($Sprite/corrode.material, "shader_parameter/cutoff_two", curcor+0.0001, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		curcor += 0.0001

@export var curcor = 0.165
var damp = 0.5
func hurt():
	if curcor < 0.05:
		damp = 1
	#This function gets called when the player hits the mob
	#$Sprite/corrode.material.set("shader_parameter/cutoff_two", 0.05)
	var tween1 = create_tween()
	curcor = curcor - ($Sprite/corrode.material.get("shader_parameter/cutoff_two") * damp)
	#damp /= 1.01
	tween1.tween_property($Sprite/corrode.material, "shader_parameter/cutoff_two", curcor, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT) 
	if ($Sprite/corrode.material.get("shader_parameter/cutoff_two") < 0.025):
		health = 0
	pass

#func _init(enemy, params):
#  enemy.dir = (enemy.target.position - enemy.position).normalized()
#
#func _physics_process(delta):
#  var motion = enemy.dir * enemy.speed
#  enemy.move_and_slide(motion)

func _on_deadanim_animation_finished(_anim_name):
	trulydead = true

func _on_vis_screen_entered():
	globals.mobs_on_screen += 1
func _on_vis_screen_exited():
	globals.mobs_on_screen -= 1


func _on_deathTimer_timeout():
	queue_free()


func _on_atk_timer_timeout():
	attacking = true
	attack_player_dir = self.global_position.direction_to(player.global_position)
	buck = false
	speed = 500
	$chargeTimer.start()
	var self_pos_down_50 = self.global_position - Vector2(0,150)
	if (self_pos_down_50.distance_to(player.get_global_position()) < 200) or (self.global_position.distance_to(player.get_global_position()) < 200):
		player.knockback(3, attack_player_dir)
		player._on_HITBOX_body_entered(self)
		attacking = false


func _on_charge_timer_timeout():
	attacking = false
	speed = 250


func _on_mobsight_entered(body):
	if body.is_in_group("player"):
		player_rad = true
		$mobsight/vis.scale *= 2
		#print($mobsight/vis.scale)

func _on_mobsight_body_exited(body):
	if body.is_in_group("player"):
		player_rad = false
		$mobsight/vis.scale /= 2
		#print($mobsight/vis.scale)
		attacking = false
		buck = false
		speed = 250
		$anim.stop()
