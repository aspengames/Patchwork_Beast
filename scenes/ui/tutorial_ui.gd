extends CanvasLayer

@onready var label = $Label
@onready var buttons = $ButtonGroup
@onready var playerv = $"../Map/Map/Player"

var onetime = true
var started = false

func _ready():
	show()
	
func _process(delta):
	if  playerv.velocity != Vector2.ZERO and not started:
		started = true
		print("player moving")
		$disappear.start()
		
func _on_disappear_timeout():
	if onetime:
		onetime = false
		#playerv.show_tip("Click to shoot, press space to dash", 5)
		hide()
