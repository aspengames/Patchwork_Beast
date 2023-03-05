extends CanvasLayer

@onready var label = $Label
@onready var buttons = $ButtonGroup
@onready var playerv = $"../Player/Player"

var started = false

func _ready():
	show()
	
func _process(delta):
	if  playerv.velocity != Vector2.ZERO and not started:
		started = true
		print("player moving")
		$disappear.start()
		
func _on_disappear_timeout():
	hide()
