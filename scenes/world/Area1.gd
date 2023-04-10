extends Area2D

@onready var player = $"../NAV/Map/Map/Player"
var completed_area1 = false
# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("get_deers")
	
func get_deers():
	await get_tree().physics_frame
	#print("awaited physics")
	await $htmlTimer.timeout
	#print("Timer timed out")
	var bodies = get_overlapping_bodies()
	#print("Overlapping bodies are ", bodies)
	var deers = []
	for body in bodies:
		if body.is_in_group("charge_mob"):
			deers.append(body)
			body.deers_healed.connect(area_completed)
	print("deers", deers)
	globals.deers = len(deers)
	print("Set globals deers to ", globals.deers)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func area_completed():
	print("Area has been completed!")
	$"../NAV/Map/Map/sleepd".visible = true
	$"../NAV/Map/Map/sleepd/col".disabled = false
	completed_area1 = true

func _on_deer_abl_body_entered(body):
	if body.is_in_group("player") and completed_area1:
		completed_area1 = false
		player.show_tip("The deer rests peacefully, thanking you for your kindness.", 3)
		player.tip_timed.connect(give_dash)
		
func give_dash():
	player.upgrade()
	player.tip_timed.disconnect(give_dash)
	player.show_tip("You can feel the deer's spirit with you.", 5)
	player.tip_timed.connect(cont_dash)
	player.get_node("ui/unim").play("pop_upgrade")
	
func cont_dash():
	player.tip_timed.disconnect(cont_dash)
	player.show_tip("", 2)
	player.tip_timed.connect(cont_dash2)
	
func cont_dash2():
	player.tip_timed.disconnect(cont_dash2)
	player.get_node("upgrade_ui").visible = true
	globals.dash_enabled = true
	player.get_node("upgrade_ui/unim").play("popin")
	player.tip_timed.connect(hide_dash)
	
func hide_dash():
	player.get_node("upgrade_ui").visible = false
	
