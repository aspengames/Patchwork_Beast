extends Area2D

@export var percent_to_corrupt = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("set_initial_corruption")

func set_initial_corruption():
	await get_tree().physics_frame
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
