extends Area2D

@onready var player = $"../NAV/Map/Map/Player"
var completed_area2 = false
# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("get_bears")
	
func get_bears():
	await get_tree().physics_frame
	#print("awaited physics")
	await $htmlTimer.timeout
	#print("Timer timed out")
	var bodies = get_overlapping_bodies()
	#print("Overlapping bodies are ", bodies)
	var bears = []
	for body in bodies:
		if body.is_in_group("bearmob"):
			bears.append(body)
			body.bears_healed.connect(area_completed)
	print("bears", bears)
	globals.bears = len(bears)
	print("Set globals bears to ", globals.bears)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func area_completed():
	print("Area has been completed!")
	$"../NAV/Map/Map/sleepb".visible = true
	$"../NAV/Map/Map/sleepb/col".disabled = false
	completed_area2 = true

func _on_deer_abl_body_entered(body):
	if body.is_in_group("player") and completed_area2:
		completed_area2 = false
		player.show_tip("The bear rests peacefully, thanking you for your kindness.", 3)
		player.tip_timed.connect(give_smash)
		
func give_smash():
	player.upgrade()
	player.tip_timed.disconnect(give_smash)
	player.show_tip("You can feel the bear's spirit with you.", 5)
	player.tip_timed.connect(cont_smash)
	player.get_node("ui/upgrade").texture = load("res://art/ui/smash_popup.png")
	player.get_node("ui/unim").play("pop_upgrade")
	
func cont_smash():
	player.tip_timed.disconnect(cont_smash)
	player.show_tip("", 2)
	player.tip_timed.connect(cont_smash2)
	
func cont_smash2():
	player.tip_timed.disconnect(cont_smash2)
	player.get_node("upgrade_ui").visible = true
	globals.smash_enabled = true
	player.get_node("upgrade_ui/Space/ButtonGroup/ButtonA").texture = load("res://art/ui/Right_click.png")
	player.get_node("upgrade_ui/Space/Label").text = "use                   to smash"
	player.get_node("upgrade_ui/unim").play("popin")
	player.tip_timed.connect(hide_smash)
	
func hide_smash():
	player.get_node("upgrade_ui").visible = false
	
