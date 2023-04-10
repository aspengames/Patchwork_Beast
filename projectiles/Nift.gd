extends Area2D

var SPEED: int = 1000
var one_time = true

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta
	if one_time:
		$woosh.play()
		one_time = false
	
func destroy():
	#print("qd")
	queue_free()

func _on_Nift_area_entered(_area):
	pass
	#destroy()
	
func _on_Nift_body_entered(body):
	#print("Entered body!")
	if body.is_in_group("charge_mob"):
		body.get_node("pars").emitting = true
		body.health -= 1
		body.hurt()
		destroy()
	if body.is_in_group("bearmob"):
		body.get_node("pars").emitting = true
		body.health -= 1
		body.hurt()
		destroy()
	if body.is_in_group("player"):
		if self.is_in_group("bossnift"):
			#print("Bossnift in player!")
			body._on_HITBOX_body_entered(self)
			destroy()
	if body.is_in_group("boss"):
		print("BOSS HIT")
		body.health -= 1
		body.hurt()
		destroy()
	#body.dead()
	#body.queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	# In future would set this to delete after 5 seconds if not coming into screen again
	$screenLeave.start()
	#destroy()
	
	

func _on_screen_leave_timeout():
	print("particle deleted")
	destroy()
