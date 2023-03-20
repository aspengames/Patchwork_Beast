extends Area2D

var SPEED: int = 500

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta
	
func destroy():
	print("qd")
	queue_free()


func _on_Nift_area_entered(_area):
	destroy()
	
func _on_Nift_body_entered(body):
	destroy()
	print("Entered body!")
	if body.is_in_group("charge_mob"):
		body.get_node("pars").emitting = true
		body.health -= 1
	if body.is_in_group("bearmob"):
		body.get_node("pars").emitting = true
		body.health -= 1
	#body.dead()
	#body.queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	# In future would set this to delete after 5 seconds if not coming into screen again
	$screenLeave.start()
	print("Started")
	

func _on_screen_leave_timeout():
	print("deleted")
	destroy()
