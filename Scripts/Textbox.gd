extends CanvasLayer

const CHAR_READ_RATE = 0.05

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []
var tween : Tween

@onready var textbox_container = $TextboxContainer
@onready var start = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label
@onready var end = $TextboxContainer/MarginContainer/HBoxContainer/End

func _ready():
	hide_textbox()
	queue_text("First test in the queue!")
	queue_text("Second test in the queue!")
	queue_text("Third test in the queue!")
	queue_text("Fourth test in the queue!")
	
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
			else:
				hide_textbox()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.visible_ratio = 1.0
				tween.stop()
				end.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_text()
				
func queue_text(next_text):
	text_queue.push_back(next_text)
	
func hide_text():
	start.text = ""
	end.text = ""
	label.text = ""
	
func hide_textbox():
	hide_text()
	textbox_container.hide()
	
func show_textbox():
	start.text = "*"
	textbox_container.show()
	
func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.visible_ratio = 0.0
	change_state(State.READING)
	show_textbox()
	tween = textbox_container.create_tween()
	tween.connect("finished", on_tween_finished)
	tween.tween_property(label, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.play()
	
func on_tween_finished():
	end.text = "v"
	change_state(State.FINISHED)
	
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("READY")
		State.READING:
			print("READING")
		State.FINISHED:
			print("FINISHED")
