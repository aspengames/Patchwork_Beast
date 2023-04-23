extends Node
var MainBGM = load("res://music/forest_walk.mp3") 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func play_music():
	$MainBGM.stream = MainBGM
	$MainBGM.play()
