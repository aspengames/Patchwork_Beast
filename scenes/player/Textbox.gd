extends CanvasLayer


const CHAR_READ_RATE = 0.025
var speed = 100
var unfreeze = true

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label1 = $TextboxContainer/MarginContainer/HBoxContainer/Label
@onready var speaker_name = $Detail/Textbox/Name
@onready var speaker_sprite = $Detail/Player

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []
var all_finished = false
var textbox_name = ""
var cur_text_done = false
var healthvis = true

var tween1
@onready var player = $"../.."
var character_queue = []


# Called when the node enters the scene tree for the first time.
func _ready():
	#print("Starting in READY")
	# Replace with function body.
	#queue_text("Hey dude")
	#pass
	
	#tween1 = get_tree().create_tween()
	#tween1.bind_node(self)
	
	all_finished = true
	hide_textbox() 
	$TextboxContainer/Button.hide()
	
func _process(_delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				speed = 0
				display_text()
				if !character_queue.is_empty():
					var char_name = character_queue.pop_front()
					set_sprite(char_name)
					if "Player" in char_name:
						char_name = "Ramis"
					set_new_name(char_name)
				
		State.READING:
			if label1.visible_ratio == 1.0 and not cur_text_done:
				$TextboxContainer/Button.show()
				cur_text_done = true
				change_state(State.FINISHED)
				#print("Done")
			if Input.is_action_just_pressed("interact_advance"):
				cur_text_done = true
				label1.visible_ratio = 1.0
				if tween1.is_running():
					tween1.stop()
				end_symbol.text = "v"
				
				$TextboxContainer/Button.show()
				change_state(State.FINISHED)
		State.FINISHED:
			if cur_text_done and Input.is_action_just_pressed("interact_advance"):
				$advance.play()
				print("played advance")
				cur_text_done = false
				change_state(State.READY)
				if text_queue.is_empty():
					all_finished = true
					#print("ALL FINISHED")
				hide_textbox()
				if text_queue.is_empty():
					globals.textbox_finished = true
					if unfreeze:
						globals.player_stop = false
					unfreeze = true
				globals.conv_amnt_comp += 1
				
				
func queue_text(next_text):
	text_queue.push_back(next_text)
	globals.player_stop = true
	
func set_new_name(txtname):
	print("Set Name to: ", txtname)
	speaker_name.text = txtname
	
var prev_sprite = "Player"
func set_sprite(sprite):
	$Detail.get_node("Player").hide()
	if sprite == "Ramis":
		sprite = "Player"
	print("Set Sprite to: ", sprite)
	#speaker_sprite = $Detail.get_node(sprite)
	$Detail.get_node(prev_sprite).hide()
	$Detail.get_node(sprite).show()
	prev_sprite = sprite
	
func queue_character(character_name):
	print("Queueing ", character_name)
	character_queue.push_back(character_name)
	
func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label1.text = ""
	if all_finished == true:
		textbox_container.hide()
		$Detail/Textbox.hide()
		if not globals.player_talking:
			speaker_sprite.hide()
		else:
			$Detail/Player.hide()
		$Overlay.hide()
		speed = 160
		if healthvis:
			player.get_node("ui/health").visible = true
		$Detail.get_node(prev_sprite).hide()
	
func show_textbox():
	all_finished = false
	start_symbol.text = "*"
	textbox_container.show()
	$Detail/Textbox.show()
	if not globals.player_talking:
		speaker_sprite.show()
	else:
		$Detail/Player.show()
	$Overlay.show()
	player.get_node("ui/health").visible = false
	
func display_text():
	$TextboxContainer/Button.hide()
	var next_text = text_queue.pop_front()
	label1.text = next_text
	label1.visible_ratio = 0.0
	
	change_state(State.READING)
	show_textbox()
	#tween1.tween_property(label1, "visible_ratio", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween1 = create_tween()
	tween1.tween_property(label1, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT) 
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
			
