#@tool
class_name Credits
extends MainScene

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const SECTION_DISTANCE: float = 2.5
const SECTION_COLOR: Color = Color.DARK_ORANGE
const SECTION_FONT_SIZE: int = 40

const LINE_DISTANCE: float = 0.5
const LINE_COLOR: Color = Color.FLORAL_WHITE
const LINE_FONT_SIZE: int = 24

const SCROLL_SPEED: float = 100.0
const SCROLL_SPEED_MULTIPLIER: float = 10.0
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
var _credits_copy: Array

var _speed_multiplier_is_active: bool
var _is_started: bool
var _is_finished: bool
var _can_change_section: bool = true

var _current_section: Array
var _current_section_time: float

var _current_line_labels: Array[Label]
var _current_line_time: float
var _current_line_index: int
#endregion

#region OnReady Variables
@onready var ColorBackground := %ColorBackground as ColorRect
@onready var LabelLine := %LabelLine as Label
#endregion

#region Virtual Methods
func _ready() -> void:
	_credits_copy = Global.credits_data.duplicate(true)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event := event as InputEventKey
		
		if key_event.pressed:
			match key_event.keycode:
				KEY_ESCAPE: _exit()
				KEY_DOWN, KEY_SPACE: _speed_multiplier_is_active = true
		
		else:
			match key_event.keycode:
				KEY_DOWN, KEY_SPACE: _speed_multiplier_is_active = false


func _physics_process(delta: float) -> void:
	var scroll_speed: float = SCROLL_SPEED * delta
	var scroll_multiplier: float = (
		delta * SCROLL_SPEED_MULTIPLIER if _speed_multiplier_is_active else delta
		)
	
	if _can_change_section:
		_current_section_time += scroll_multiplier
		
		if _current_section_time >= SECTION_DISTANCE:
			_current_section_time -= SECTION_DISTANCE
			
			if _credits_copy.size() > 0:
				_is_started = true
				_current_section = _credits_copy[0]
				_current_line_index = 0
				
				_credits_copy.remove_at(0)
				
				_append_current_line()
	
	else:
		_current_line_time += scroll_multiplier
		
		if _current_line_time >= LINE_DISTANCE:
			_current_line_time -= LINE_DISTANCE
			
			_append_current_line()
	
	if _speed_multiplier_is_active:
		scroll_speed *= SCROLL_SPEED_MULTIPLIER
	
	if _current_line_labels.size() > 0:
		for label: Label in _current_line_labels:
			label.position.y -= scroll_speed
			
			if label.position.y < -label.get_line_height():
				_current_line_labels.erase(label)
				label.queue_free()
	
	elif _is_started:
		_exit()
#endregion

#region Public Methods
#endregion

#region Private Methods
func _append_current_line() -> void:
	var line := LabelLine.duplicate() as Label
	
	line.text = str(_current_section[0])
	
	_current_section.remove_at(0)
	
	_current_line_labels.append(line)
	
	var line_is_section: bool = _current_line_index == 0
	var line_font_size: int = SECTION_FONT_SIZE if line_is_section else LINE_FONT_SIZE
	var line_font_color: Color = SECTION_COLOR if line_is_section else LINE_COLOR
	
	line.add_theme_font_size_override(&"font_size", line_font_size)
	line.add_theme_color_override(&"font_color", line_font_color)
	
	add_child(line)
	
	if _current_section.size() > 0:
		_current_line_index += 1
		_can_change_section = false
	
	else:
		_can_change_section = true


func _exit() -> void:
	if not _is_finished:
		_is_finished = true
		
		Global.change_main_scene(Global.MainSceneType.START_MENU)
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
