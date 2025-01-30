#@tool
class_name CustomerPanel
extends PanelContainer

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const TWEEN_SCALE_FROM_VALUE: float = 0.1
const TWEEN_SCALE_SPEED: float = 0.75
const TWEEN_MODULATE_SPEED: float = 0.25
const TWEEN_LABEL_VISIBLE_RATIO_SPEED: float = 30.0
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
var _tween: Tween
#endregion

#region OnReady Variables
# Background
@onready var VBoxBackground := %VBoxBackground as VBoxContainer

# Customer
@onready var PanelCustomer := %PanelCustomer as PanelContainer
@onready var VBoxCustomer := %VBoxCustomer as VBoxContainer
@onready var LabelCustomer := %LabelCustomer as Label
@onready var MarginCustomer := %MarginCustomer as MarginContainer
@onready var TextureCustomer := %TextureCustomer as TextureRect

# Description
@onready var PanelDescription := %PanelDescription as PanelContainer
@onready var ScrollDescription := %ScrollDescription as ScrollContainer
@onready var MarginDescription := %MarginDescription as MarginContainer
@onready var LabelDescription := %LabelDescription as Label
#endregion

#region Virtual Methods
#endregion

#region Public Methods
func update_with_customer(customer: Customer) -> void:
	if _tween != null:
		_tween.kill()
	
	LabelCustomer.text = customer.name
	LabelCustomer.modulate.a = 0.0
	
	TextureCustomer.pivot_offset = TextureCustomer.size / 2.0
	TextureCustomer.texture = customer.texture
	TextureCustomer.modulate.a = 0.0
	
	LabelDescription.text = str(customer.opening_texts.pick_random())
	LabelDescription.visible_ratio = 0.0
	
	_tween = create_tween()
	
	var tweener: PropertyTweener = _tween.tween_property(
		TextureCustomer, ^"scale", Vector2.ONE, TWEEN_SCALE_SPEED
		)
	
	var tween_label_speed: float = LabelDescription.text.length() / TWEEN_LABEL_VISIBLE_RATIO_SPEED
	
	tweener.from(Vector2.ONE * TWEEN_SCALE_FROM_VALUE)
	tweener.set_ease(Tween.EASE_OUT)
	tweener.set_trans(Tween.TRANS_BACK)
	
	_tween.parallel().tween_property(LabelCustomer, ^"modulate:a", 1.0, TWEEN_MODULATE_SPEED)
	_tween.parallel().tween_property(TextureCustomer, ^"modulate:a", 1.0, TWEEN_MODULATE_SPEED)
	_tween.parallel().tween_property(LabelDescription, ^"visible_ratio", 1.0, tween_label_speed)
#endregion

#region Private Methods
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
