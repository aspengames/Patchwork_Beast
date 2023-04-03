extends CharacterBody2D

""" -------- DECLARATION -------- """
#input and direction
var horizontal_input
var vertical_input
var direction = Vector2()

var only_dash_while_walk = true
var able_to_dash = true
var invincible = false
var speed = 400
var dead = false
var attacking = false
var knockback_dir = Vector2()
var knockback_str = 1
var knock = false
var kb_onetime = false
#velocity vectors
#var velocity = Vector2()
#var delta_velocity = Vector2()

#acceleration/deceleration lerping weight
const ACCEL_WEIGHT = .3

var display_name = "Ramis"
var atkTimer
var hurtTimer
#init the nift
var NIFT: PackedScene = preload("res://projectiles/Nift.tscn")
var nift_dir

""" -------- FUNCTIONS -------- """
#initialize variables
func _ready():
	horizontal_input = 0
	vertical_input = 0
	
	atkTimer = $atkTimer
	hurtTimer = $hurtTimer
	
	$Camera2D/Textbox.set_new_name(display_name)
	#temporary name setter
	pass

#executed each frame
func _physics_process(_delta):
	#boolean returning if any moving key is pressed
	var is_moving = Input.is_action_pressed("move_up") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left") 
	if globals.player_stop:
		is_moving = false
	""" Movement manager
	"    if is_moving
	"      then modify speed and inputs depending on player's request
	"    else
	"     conserve last direction inputs from the player and lerp speed to 0
	"""
	#if is_moving:
	
	""" Direction and speed vectors assignement
	"    normalizing the direction vector to avoid diagonal super speed
	"    and creating a speed vector with both "spacialized" speed ; x and y axis
	"""
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	#multiplying valors to get velocity vectors
	velocity = direction * speed
	if knock:
		direction = knockback_dir
		velocity = direction * speed * knockback_str
		if kb_onetime:
			kb_onetime = false
			$kbTimer.start()
		
	if globals.player_stop:
		velocity = Vector2.ZERO
	if velocity == Vector2.ZERO:
		only_dash_while_walk = false
		if not attacking:
			$AnimationTree.get("parameters/playback").travel("Idle")
	else:
		if not is_moving:
			only_dash_while_walk = false
			if not attacking:
				$AnimationTree.get("parameters/playback").travel("Idle")
		else:
			if not attacking:
				only_dash_while_walk = true
				$AnimationTree.get("parameters/playback").travel("Walk")
				$AnimationTree.set("parameters/Idle/blend_position", velocity)
				$AnimationTree.set("parameters/Walk/blend_position", velocity)
			else:
				only_dash_while_walk = false
				if not attacking:
					$AnimationTree.get("parameters/playback").travel("Idle")
			
	if Input.is_action_just_pressed("space") and able_to_dash and only_dash_while_walk and globals.dash_enabled:
		only_dash_while_walk = false
		able_to_dash = false
		$dashTimer.start()
		dash(direction)
		$AnimationTree.get("parameters/playback").travel("Dash")
		$AnimationTree.set("parameters/Dash/blend_position", velocity)
			
	if Input.is_action_just_pressed("action_attack") and atkTimer.is_stopped() and not dead and not globals.player_stop:# and not $"../../MainMenu".visible:
			#get_global_mouse_position() for shooting towards mouse
			#print("rotation is: ",  rotation)
#			if globals.tutorial:
#				$explosion.emitting = true
#				return			
			print("clickattack")
			attacking = true
			#print("Set attacking to", attacking)
			#print("A")
			var nift_direction = self.global_position.direction_to(get_global_mouse_position())
			throw_nift(nift_direction)
			
	if enemyin and hurtTimer.is_stopped() and not invincible:
		enemyin = false
		health -= 20
		$ui/health.value = health
		print(health)
		hurtTimer.start()
		
	if health <= 0 and not dead:
		dead = true
		$AnimationPlayer2.play("death")
		globals.player_stop = true
		globals.global_dead = true
	#applying the needed vector to the object, to make it move thanks to the move_and_slide function
	if not attacking:
		move_and_slide()
		
	pass

func dash(player_dir):
	invincible = true
	knock = true
	knockback_dir = direction
	kb_onetime = true
	knockback_str = 4
	
var enemyin = false
var health = 80

func _on_HITBOX_body_entered(body):
	if body.is_in_group("charge_mob") and hurtTimer.is_stopped() and body.attacking:
		enemyin = true
		health -= 5
		$ui/health.value = health
		#print(health)
		hurtTimer.start()
		body.attacking = false
		knockback(3, body.attack_player_dir)
	if body.is_in_group("earthatk"):
		#print("ow")
		health -= 10
		$ui/health.value = health
		print(health)
		print(body.get_parent().attack_player_dir)

func _on_HITBOX_body_exited(body):
	if body.is_in_group("charge_mob"):
		#hurtTimer.stop()
		enemyin = false

func throw_nift(nift_direction: Vector2):
	print("throw nift called")
	if NIFT:
		$AnimationTree.get("parameters/playback").travel("Shoot")
		$AnimationTree.set("parameters/Shoot/blend_position", nift_direction)
		nift_dir = nift_direction
		
func actual_throw_nift():
		print("called")
		var nift_direction = nift_dir
		var nift = NIFT.instantiate()
		get_tree().current_scene.get_node("Player/projectiles").add_child(nift)
		nift.global_position = self.global_position#self.global_positions
		#nift.z_index = -1
		var nift_rotation = nift_direction.angle()
		if -PI/4 < nift_rotation:
			if nift_rotation < PI/4:
				nift.global_position = $Staff1.global_position
		if PI/4 < nift_rotation:
			if nift_rotation < 3*PI/4:
				nift.global_position = $Staff1.global_position
		if -PI < nift_rotation:
			if nift_rotation < -3*PI/4:
				nift.global_position = $Staff2.global_position
		if 3*PI/4 < nift_rotation:
			if nift_rotation < PI:
				nift.global_position = $Staff2.global_position
		if -3*PI/4 < nift_rotation:
			if nift_rotation < -PI/4:
				nift.global_position = $Staff2.global_position
		nift.rotation = nift_rotation
		#$"../laserbgm".play()
		atkTimer.start()
		#print("Started Atk Timer")
		nift.get_node("pars").emitting = true
		#$AnimationTree.set("parameters/Idle/blend_position", nift_direction)

		#print(nift_direction)
		#var mouse_direction = Vector3(nift_direction.x, nift_direction.y, 0)
		#nift.get_node("pars").process_material.set("direction", mouse_direction)
		#print($pars.process_material.get("direction"))
#		var is_moving = Input.is_action_pressed("move_up") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left")
#		if not is_moving:
#			$AnimationTree.get("parameters/playback").travel("Idle")
#		else:
#			$AnimationTree.get("parameters/playback").travel("Walk")
#			$AnimationTree.set("parameters/Idle/blend_position", get_global_mouse_position())
#			$AnimationTree.set("parameters/Walk/blend_position", get_global_mouse_position())
func _on_atk_timer_timeout():
	attacking = false
	#print("Set attacking to", attacking)

func show_tip(text, time):
	$tips.visible = true
	$tips/Label.text = text
	$tips/tiptimer.wait_time = time
	$tips/tiptimer.start()
	
func _on_tiptimer_timeout():
	$tips.visible = false


func _on_PLAYERANIM_finished(anim_name):
	if anim_name == "death":
		$transition.visible = true
		$transition/anim.play_backwards("fade")

func _on_PLAYERTRANSITION_finished(anim_name):
	if anim_name == "fade" and dead:
		get_tree().change_scene_to_file("res://scenes/world/Level.tscn")

func knockback(strength, mob_dir):
	knockback_dir = mob_dir
	knockback_str = strength
	knock = true
	kb_onetime = true
	#print(mob_dir, strength, "n")


func _on_kb_timer_timeout():
	invincible = false
	knock = false
	velocity = Vector2.ZERO
	
func _on_dash_timer_timeout():
	able_to_dash = true
