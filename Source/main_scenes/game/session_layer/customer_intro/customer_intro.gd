#@tool
class_name CustomerIntro
extends PanelContainer

#region Signals
signal accepted(state: bool)
#endregion

#region Enums
#endregion

#region Constants
const TWEEN_SKIP_SPEED_SCALE: float = 8.0
const TWEEN_SELF_MODULATE_SPEED: float = 0.5
const TWEEN_LABEL_VISIBLE_RATIO_SPEED: float = 20.0
const TWEEN_BUTTONS_MODULATE_SPEED: float = 0.25
const TWEEN_BUTTONS_MODULATE_DELAY: float = 0.25
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
var _tween: Tween
#endregion

#region OnReady Variables
@onready var ColorBackgroundShader := %ColorBackgroundShader as ColorRect
@onready var VBoxBackground := %VBoxBackground as VBoxContainer
@onready var TextureCustomer := %TextureCustomer as TextureRect
@onready var LabelOpening := %LabelOpening as Label

# Buttons
@onready var HBoxButtons := %HBoxButtons as HBoxContainer
@onready var ButtonRefuse := %ButtonRefuse as Button
@onready var ButtonAccept := %ButtonAccept as Button
#endregion

#region Virtual Methods
func _ready() -> void:
	_reset()
	
	for button: Button in [ButtonAccept, ButtonRefuse]:
		button.pressed.connect(_on_button_pressed.bind(button))


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_input := event as InputEventKey
		
		if key_input.pressed:
			match key_input.keycode:
				KEY_ESCAPE, KEY_SPACE, KEY_ENTER when _tween != null:
					_tween.set_speed_scale(TWEEN_SKIP_SPEED_SCALE)
#endregion

#region Public Methods
func show_customer_intro(customer: Customer) -> void:
	_reset()
	
	visible = true
	
	TextureCustomer.texture = customer.texture
	LabelOpening.text = customer.description
	
	_tween = create_tween()
	
	var tween_label_speed: float = LabelOpening.text.length() / TWEEN_LABEL_VISIBLE_RATIO_SPEED
	
	_tween.tween_property(self, ^"modulate:a", 1.0, TWEEN_SELF_MODULATE_SPEED)
	_tween.parallel().tween_property(LabelOpening, ^"visible_ratio", 1.0, tween_label_speed)
	
	_tween.chain().tween_property(
		HBoxButtons, ^"modulate:a", 1.0, TWEEN_BUTTONS_MODULATE_SPEED
	).set_delay(TWEEN_BUTTONS_MODULATE_DELAY)
#endregion

#region Private Methods
func _reset() -> void:
	if _tween != null:
		_tween.kill()
	
	visible = false
	modulate.a = 0.0
	
	LabelOpening.visible_ratio = 0.0
	HBoxButtons.modulate.a = 0.0
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_button_pressed(button: Button) -> void:
	match button:
		ButtonAccept:
			accepted.emit(true)
			_reset()
		
		ButtonRefuse:
			accepted.emit(false)
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
