extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Our custom screen shake scripts
func small_shake() -> void:
	$screenshake.start(0.1, 15, 4, 0)
	
func med_shake() -> void:
	$screenshake.start(0.2,15,8,0)
	
func large_shake() -> void:
	$screenshake.start(0.3,15,16,0)
