extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@onready var player = $"../Player/Player"
var dist = 999999
var alive = true
var trulydead = false
var buck = false
var attacking = false
var attack_player_dir
var speed = 250

@export var health = 5

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
	if (self.global_position.distance_to(player.get_global_position()) < 1000) and (self.global_position.distance_to(player.get_global_position()) > 100) and not trulydead:
		if not $anim.is_playing():
			$anim.play()
		if buck:
			return
		#self.global_position += player_dir
		#self.move_and_slide(player_dir * 500)
		if (self.global_position.distance_to(player.get_global_position()) < 500) and not buck and not attacking:
			buck = true
			attack_player_dir = self.global_position.direction_to(player.global_position)
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
		
		self.move_and_slide()	
		
		if not $anim.is_playing():
			$anim.play()
	else:
		$anim.stop()
		
	if health < 1 and alive:
		alive = false
		$deadanim.play("dead")
		$col.disabled = true
		
	if trulydead and $pars.emitting == false:
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


func _on_atk_timer_timeout():
	attacking = true
	buck = false
	speed = 500
	$chargeTimer.start()


func _on_charge_timer_timeout():
	attacking = false
	speed = 250
