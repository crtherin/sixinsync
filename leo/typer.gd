extends Control

@export var typing_speed: float = 0.50 # Time between letters (seconds)
#@export var visible_duration: float = 2.0 # Bubble stays visible (seconds)
@export var label : Label
@export var mumbleManager : MumbleManager

var full_text: String = ""
var is_typing: bool = false
var index: int
var timer: Timer
var skip: bool


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_write_char)
	add_child(timer)
	#hide() # Start hidden

# Show the bubble and start typing
func show_bubble(text: String):
	# Timer setup
	if is_typing: # Stop any ongoing typing
		_reset()
	label.text = "" # Clear text
	full_text = text
	#show()
	_start_typing()

func _reset():
	timer.stop()
	is_typing = false
	skip = false
	
# Start the typing animation
func _start_typing():
	is_typing = true
	skip = false
	index = 0
	timer.start(typing_speed) # Start typing

# Add characters progressively
func _type_next_char():
	if index < full_text.length():
		label.text += full_text[index]
		mumbleManager.mumble(full_text[index])
		timer.start(typing_speed)
		index += 1
	else:
		# Typing is done;
		is_typing = false

# Hide the bubble after the timer
func _on_write_char():
	if(!skip):
		_type_next_char()
	else:
		_reset()
		label.text = full_text

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_input := event as InputEventKey
		if key_input.pressed:
			match key_input.keycode:
				KEY_SPACE: skip = true
