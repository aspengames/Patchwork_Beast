extends Node
var MainBGM = load("res://music/forest_walk.mp3")
var creditsBGM = load("res://music/credits.mp3")
var bossBGM = load("res://music/bossfight.mp3")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func play_music():
	$MainBGM.stream = MainBGM
	$MainBGM.play()

func play_boss():
	$MainBGM.stream = bossBGM
	$MainBGM.play()

func play_credits():
	$MainBGM.stream = creditsBGM
	$MainBGM.volume_db = -35
	$MainBGM.play()
