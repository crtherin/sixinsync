extends CanvasLayer

@export var typing_speed: float = 0.50 # Time between letters (seconds)
@export var visible_duration: float = 2.0 # Bubble stays visible (seconds)
var full_text: String = ""
var is_typing: bool = false
var timer: Timer

@onready var label = $Panel/Label
@onready var panel = $Panel

func _ready():
	# Timer setup
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	hide() # Start hidden

# Show the bubble and start typing
func show_bubble(text: String):
	if is_typing: # Stop any ongoing typing
		timer.stop()
		is_typing = false
	label.text = "" # Clear text
	full_text = text
	show()
	_start_typing()

# Start the typing animation
func _start_typing():
	is_typing = true
	panel.show()
	label.text = ""
	timer.start(typing_speed)
	call_deferred("_type_next_char", 0) # Start typing

# Add characters progressively
func _type_next_char(index: int):
	if index < full_text.length():
		label.text += full_text[index]
		timer.start(typing_speed)
		call_deferred("_type_next_char", index + 1)
	else:
		# Typing is done; start the visibility timer
		is_typing = false
		timer.start(visible_duration)
		timer.timeout.connect(_on_hide_bubble)

# Hide the bubble after the timer
func _on_hide_bubble():
	hide()
