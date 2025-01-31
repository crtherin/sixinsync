#@tool
class_name CharonLayer
extends CanvasLayer

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const TAX_MULTIPLIER: int = 3

const TWEEN_GRADIENT_SPEED: float = 2.5
const TWEEN_LABEL_VISIBLE_RATIO_SPEED: float = 30.0
const TWEEN_LABEL_SKIP_SPEED_SCALE: float = 8.0
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
var _tween_background: Tween
var _tween_label: Tween
#endregion

#region OnReady Variables
@onready var MumbleManagerRef := %MumbleManagerRef as MumbleManager

@onready var PanelBackground := %PanelBackground as PanelContainer
@onready var PanelBackgroundStyle := PanelBackground.get_theme_stylebox(&"panel") as StyleBoxTexture
@onready var PanelBackgroundTexture := PanelBackgroundStyle.texture as GradientTexture2D
@onready var ColorShader := %ColorShader as ColorRect
@onready var MarginBackground := %MarginBackground as MarginContainer
@onready var VBoxBackground := %VBoxBackground as VBoxContainer
@onready var PanelShadow := %PanelShadow as PanelContainer
@onready var TextureCharon := %TextureCharon as TextureRect
@onready var LabelCharon := %LabelCharon as Label
@onready var ButtonConfirm := %ButtonConfirm as GameButton
#endregion

#region Virtual Methods
func _ready() -> void:
	# Defaults
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	# Connections
	Global.charon_requested.connect(_on_Global_charon_requested)
	ButtonConfirm.pressed.connect(_on_ButtonConfirm_pressed)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_input := event as InputEventKey
		
		if key_input.pressed:
			match key_input.keycode:
				KEY_ESCAPE, KEY_SPACE, KEY_ENTER when _tween_label != null:
					_tween_label.set_speed_scale(TWEEN_LABEL_SKIP_SPEED_SCALE)
	
	elif event is InputEventMouseButton:
		var mouse_button_input := event as InputEventMouseButton
		
		if mouse_button_input.pressed:
			match mouse_button_input.button_index:
				MOUSE_BUTTON_LEFT when _tween_label != null:
					_tween_label.set_speed_scale(TWEEN_LABEL_SKIP_SPEED_SCALE)
#endregion

#region Public Methods
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_Global_charon_requested() -> void:
	# Set paused state and visibility
	Global.is_paused = true
	get_tree().paused = true
	visible = true
	
	# Calculate the tax value and reset Charon's round
	var charon_tax_rand: int = randi_range(
		Global.CHARON_TAX_TOTAL_BOUNDS.x, Global.CHARON_TAX_TOTAL_BOUNDS.y
		)
	
	Global.charon_event_counter += 1
	Global.charon_tax_total = ((Global.charon_event_counter - 1) * TAX_MULTIPLIER) + charon_tax_rand
	Global.reset_charon_round()
	
	# Update and prepare nodes
	LabelCharon.visible_ratio = 0.0
	LabelCharon.text = str(Global.charon_data.evening[randi_range(0, 13)] % Global.charon_tax_total)
	
	ButtonConfirm.visible = false
	
	MumbleManagerRef.mumble(LabelCharon.text)
	
	# Set animations
	if _tween_background != null:
		_tween_background.kill()
	
	_tween_background = create_tween()
	_tween_background.set_loops()
	
	_tween_background.tween_property(
		PanelBackgroundTexture, ^"fill_from:x", 1.0, TWEEN_GRADIENT_SPEED
		)
	
	_tween_background.tween_property(
		PanelBackgroundTexture, ^"fill_from:x", 0.0, TWEEN_GRADIENT_SPEED
		)
	
	if _tween_label != null:
		_tween_label.kill()
	
	_tween_label = create_tween()
	
	var tween_label_speed: float = LabelCharon.text.length() / TWEEN_LABEL_VISIBLE_RATIO_SPEED
	
	_tween_label.tween_property(LabelCharon, ^"visible_ratio", 1.0, tween_label_speed)
	_tween_label.tween_callback(ButtonConfirm.show)
	
	_tween_label.tween_callback(MumbleManagerRef.skip)


func _on_ButtonConfirm_pressed() -> void:
	# Unset paused state and visibility
	Global.is_paused = false
	get_tree().paused = false
	visible = false
	
	# Subtract the current gold with Charon's tax
	Global.adjust_gold(-Global.charon_tax_total)
	
	# Game over
	if Global.gold < 0:
		Global.change_main_scene(Global.MainSceneType.END_DEFEAT)
	
	# Next custmomer
	else:
		Global.next_customer_requested.emit()
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
