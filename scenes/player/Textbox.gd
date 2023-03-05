extends CanvasLayer


const CHAR_READ_RATE = 0.05
var speed = 100

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label1 = $TextboxContainer/MarginContainer/HBoxContainer/Label

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []
var all_finished = false
var textbox_name = ""

var tween1
@onready var player = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("Starting in READY")
	# Replace with function body.
	#queue_text("Hey dude")
	#pass
	
	tween1 = create_tween()
	
	all_finished = true
	hide_textbox() 
	
func _process(_delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				speed = 0
				display_text()
		State.READING:
			if Input.is_action_just_pressed("interact"):
				label1.visible_ratio = 1.0
				tween1.stop()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("interact"):
				change_state(State.READY)
				if text_queue.is_empty():
					all_finished = true
					#print("ALL FINISHED")
				hide_textbox()
				globals.player_stop = false

func queue_text(next_text):
	text_queue.push_back(next_text)
	globals.player_stop = true
	
func set_new_name(_txtname):
	pass
	
func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label1.text = ""
	if all_finished == true:
		textbox_container.hide()
		$Detail/Textbox.hide()
		$Detail/TalkNPC.hide()
		$Overlay.hide()
		speed = 160
	
func show_textbox():
	all_finished = false
	start_symbol.text = "*"
	textbox_container.show()
	$Detail/Textbox.show()
	$Detail/TalkNPC.show()
	$Overlay.show()
	
func display_text():
	var next_text = text_queue.pop_front()
	label1.text = next_text
	label1.visible_ratio = 0.0
	
	change_state(State.READING)
	show_textbox()
	#tween1.tween_property(label1, "visible_ratio", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween1.tween_property(label1, "visible_ratio", Vector2(0.0, 1.0), 1) 
	#tween1.start()

func _on_Tween_tween_all_completed():
	end_symbol.text = "v"
	change_state(State.FINISHED)

func change_state(next_state):
	current_state = next_state
	#match current_state:
	#	State.READY:
	#		print("changing to READY")
	#	State.READING:as
	#		print("changing to READING")
	#	State.FINISHED:
	#		print("changing to as	FINISHED")
			
