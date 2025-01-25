#@tool
class_name Cup
extends TextureRect

#region Signals
#endregion

#region Enums
#endregion

#region Constants
#endregion

#region Export Variables
@export var parent: MarginContainer
@export var panel_customer: PanelContainer
@export var panel_trash: PanelContainer
#endregion

#region Public Variables
var is_pressed: bool: set = _set_pressed
var initial_position: Vector2
#endregion

#region Private Variables
#endregion

#region OnReady Variables
@onready var VBoxLayers := %VBoxLayers as VBoxContainer
@onready var LayerBubbles := %LayerBubbles as TextureRect
@onready var LayerExtras := %LayerExtras as TextureRect
@onready var LayerTea := %LayerTea as TextureRect
@onready var LayerMilk := %LayerMilk as TextureRect
#endregion

#region Virtual Methods
func _ready() -> void:
	Global.item_dropped_in_cup.connect(_on_item_dropped_in_cup)
	gui_input.connect(_on_gui_input)
	get_window().size_changed.connect(_on_window_size_changed)
	
	reset()
	
	await get_tree().process_frame
	
	initial_position = global_position


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		
		if not mouse_button_event.pressed:
			match mouse_button_event.button_index:
				MOUSE_BUTTON_LEFT:
					var mouse_position: Vector2 = get_global_mouse_position()
					
					create_tween().tween_property(self, ^"global_position", initial_position, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
					
					if Global.cup_is_dragging:
						
						if panel_customer.get_global_rect().has_point(mouse_position):
							Global.cup_dropped_on_customer.emit()
						
						elif panel_trash.get_global_rect().has_point(mouse_position):
							Global.cup_dropped_on_trash.emit()
							reset()
					
					is_pressed = false
					Global.cup_is_dragging = false


func _physics_process(_delta: float) -> void:
	if is_pressed and not Engine.is_editor_hint():
		global_position = global_position.lerp((get_global_mouse_position() - (size * scale) / 2.0), 0.1)
#endregion

#region Public Methods
func reset() -> void:
	for layer: TextureRect in [LayerBubbles, LayerExtras, LayerMilk]:
		layer.visible = false
		#layer.texture = null
		layer.modulate = Color.WHITE
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_item_dropped_in_cup(item: Item) -> void:
	print("Item: %s, dropped on cup" % item)
	
	match item.data.type:
		ItemData.Type.BOBA_TAPIOCA, ItemData.Type.BOBA_POPPING:
			LayerBubbles.visible = true
			#LayerBubbles.texture = item.data.cup_texture
			LayerBubbles.modulate = item.data.cup_modulate
		
		ItemData.Type.TEA_BLACK, ItemData.Type.TEA_GREEN, ItemData.Type.TEA_OOLONG:
			LayerTea.visible = true
			#LayerTea.texture = item.data.cup_texture
			LayerTea.modulate = item.data.cup_modulate
		
		ItemData.Type.MILK_DIARY, ItemData.Type.MILK_ALMOND, ItemData.Type.MILK_SUCCUBUS:
			LayerMilk.visible = true
			#LayerMilk.texture = item.data.cup_texture
			LayerMilk.modulate = item.data.cup_modulate
		
		ItemData.Type.EXTRAS_ICE, ItemData.Type.EXTRAS_SUGAR, ItemData.Type.EXTRAS_SWEETENER, ItemData.Type.EXTRAS_FRUIT_SYRUP: 
			LayerExtras.visible = true
			#LayerExtras.texture = item.data.cup_texture
			LayerExtras.modulate = item.data.cup_modulate
		
		ItemData.Type.EXTRAS_FRUIT_PIECES, ItemData.Type.EXTRAS_TEARS, ItemData.Type.EXTRAS_BLOOD:
			LayerExtras.visible = true
			#LayerExtras.texture = item.data.cup_texture
			LayerExtras.modulate = item.data.cup_modulate


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		
		if mouse_button_event.pressed:
			match mouse_button_event.button_index:
				MOUSE_BUTTON_LEFT:
					is_pressed = true
					Global.cup_is_dragging = true


func _on_window_size_changed() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	
	var viewport_size: Vector2 = get_viewport_rect().size
	
	global_position.x = clampf(global_position.x, 0.0, viewport_size.x - size.x)
	global_position.y = clampf(global_position.y, 0.0, viewport_size.y - size.y)
	
	initial_position = global_position
#endregion

#region SubClasses
#endregion

#region Setter Methods
func _set_pressed(arg: bool) -> void:
	is_pressed = arg
	
	pivot_offset = size / 2.0
	create_tween().tween_property(self, ^"scale", Vector2.ONE * (0.5 if is_pressed else 1.0), 0.15)
#endregion

#region Getter Methods
#endregion
