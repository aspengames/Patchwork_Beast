extends CanvasLayer

@onready var label = $UseLeft_Click/Label
@onready var buttons = $UseLeft_Click/ButtonGroup
@onready var playerv = $"../NAV/Map/Map/Player"

var onetime = true
var started = false

func _ready():
	pass
	
func _process(delta):
	if not started:
		started = true
		$disappear.start()
		
func _on_disappear_timeout():
	if onetime:
		onetime = false
		#playerv.show_tip("Click to shoot, press space to dash", 5)
		hide()
