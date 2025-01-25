#@tool
class_name Menu
extends CanvasLayer

#region Signals
#endregion

#region Enums
#endregion

#region Constants
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
#endregion

#region OnReady Variables
@onready var ColorMenuBackground := %ColorMenuBackground as ColorRect
@onready var MarginMenuBackground := %MarginMenuBackground as MarginContainer
@onready var VBoxMenuBackground := %VBoxMenuBackground as VBoxContainer
@onready var LabelMenuTitle := %LabelMenuTitle as Label
@onready var VBoxMenuButtons := %VBoxMenuButtons as VBoxContainer
@onready var ButtonResume := %ButtonResume as Button
@onready var ButtonExit := %ButtonExit as Button
@onready var LabelMenuWarning := %LabelMenuWarning as Label

@onready var StartMenu := %StartMenu as ColorRect
#endregion

#region Virtual Methods
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	visible = true
	LabelMenuWarning.visible = false
	
	set_pause_screen(true)
	
	Global.warning_message_requested.connect(_on_warning_message_requested)
	
	for button: Button in [ButtonResume, ButtonExit]:
		button.pressed.connect(_on_button_pressed.bind(button))


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_input := event as InputEventKey
		
		if key_input.pressed:
			match key_input.keycode:
				KEY_ESCAPE: set_pause_screen(not Global.is_paused)
#endregion

#region Public Methods
func set_pause_screen(state: bool) -> void:
	var tween: Tween = create_tween()
	
	Global.is_paused = state
	get_tree().paused = state
	
	if state:
		ColorMenuBackground.visible = true
		tween.tween_property(ColorMenuBackground, ^"modulate:a", 1.0, 0.25).from(0.0)
	
	else:
		tween.tween_property(ColorMenuBackground, ^"modulate:a", 0.0, 0.25).from(1.0)
		tween.tween_callback(ColorMenuBackground.hide)
		
func set_start_screen(state: bool) -> void:	
	Global.is_paused = state
	get_tree().paused = state
	set_pause_screen(state)
	
	var tween: Tween = create_tween()
	
	tween.tween_property(StartMenu, ^"modulate:a", 0.0, 0.25).from(1.0)
	tween.tween_callback(StartMenu.hide)
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_warning_message_requested(text: String) -> void:
	LabelMenuWarning.text = text
	LabelMenuWarning.visible = true
	
	var tween: Tween = create_tween()
	var original_position: Vector2 = LabelMenuWarning.position
	
	for __: int in 10:
		var random_position_offset: Vector2 = Vector2(
			randf_range(-50.0, 50.0),
			randf_range(-25.0, 25.0)
			)
		
		tween.chain().tween_property(
			LabelMenuWarning, ^"position", original_position + random_position_offset, 0.03
			).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	
	tween.parallel().tween_property(
		LabelMenuWarning, ^"position", original_position, 0.1
		).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.chain().tween_callback(LabelMenuWarning.hide).set_delay(0.25)


func _on_button_pressed(button: Button) -> void:
	match button:
		ButtonResume: set_pause_screen(false)
		ButtonExit: get_tree().quit()
		
func _on_button_start_pressed():
	set_start_screen(false);
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
