extends Area2D

@export var percent_to_corrupt = 0.0
@onready var player = $"../../NAV/Map/Map/Player"
# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("set_initial_corruption")

func set_initial_corruption():
	await get_tree().physics_frame
	#print("awaited physics")
	await $htmlCorruptTimer.timeout
	#print("Timer timed out")
	var bodies = get_overlapping_bodies()
	#print("Overlapping bodies are ", bodies)
	var trees = []
	for body in bodies:
		if body.is_in_group("tree"):
			trees.append(body)
	#print("Trees are", trees)
	for tree in trees:
		#pass
		tree.get_owner().set_corruption(percent_to_corrupt)

func animate_uncorrupt():
	var bodies = player.get_node("treeUncorrupt").get_overlapping_bodies()
	#print("Overlapping bodies are ", bodies)
	var trees = []
	for body in bodies:
		if body.is_in_group("tree"):
			trees.append(body)
	#print("Trees are", trees)
	for tree in trees:
		#pass
		#tree.get_owner().animatetree = true
		tree.get_owner().uncorrode()
		
	var bodies_total = get_overlapping_bodies()
	#print("Overlapping bodies are ", bodies)
	var trees_total = []
	for body in bodies_total:
		if body.is_in_group("tree"):
			if body not in trees:
				trees_total.append(body)
	for tree in trees_total:
		tree.get_owner().set_corruption(0)

func set_corruption(percor):
	#print("Timer timed out")
	var bodies = get_overlapping_bodies()
	#print("Overlapping bodies are ", bodies)
	var trees = []
	for body in bodies:
		if body.is_in_group("tree"):
			trees.append(body)
	#print("Trees are", trees)
	for tree in trees:
		#pass
		tree.get_owner().set_corruption(percor)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
