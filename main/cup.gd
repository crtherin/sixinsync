#@tool
class_name Cup
extends PanelContainer

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

var selected_tea: ItemData.Type
var selected_milk: ItemData.Type
var selected_bubble: ItemData.Type
var selected_extras: Array[ItemData.Type]
#endregion

#region Private Variables
#endregion

#region OnReady Variables
@onready var LayerCup := %LayerCup as TextureRect
@onready var LayerBubbles := %LayerBubbles as TextureRect
@onready var LayerTea := %LayerTea as TextureRect
@onready var LayerMilk := %LayerMilk as TextureRect
@onready var PanelExtrasLayers := %PanelExtrasLayers as PanelContainer
@onready var PanelExtrasLayersBack := %PanelExtrasLayersBack as PanelContainer
#endregion

#region Virtual Methods
func _ready() -> void:
	Global.item_dropped_in_cup.connect(_on_item_dropped_in_cup)
	gui_input.connect(_on_gui_input)
	get_window().size_changed.connect(_on_window_size_changed)
	
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
							var isOk = check_selection()
							Global.customer_drop(isOk)
							if isOk:
								reset()
						
						elif panel_trash.get_global_rect().has_point(mouse_position):
							#Global.cup_dropped_on_trash.emit()
							reset()
					
					is_pressed = false
					Global.cup_is_dragging = false


func _physics_process(_delta: float) -> void:
	if is_pressed and not Engine.is_editor_hint():
		global_position = global_position.lerp((get_global_mouse_position() - (size * scale) / 2.0), 0.1)
#endregion

#region Public Methods
func check_selection() -> bool:
	if Global.current_quest.tea != selected_tea:
		print("wrong tea")
		print(selected_tea)
		print(Global.current_quest.tea)
		return false
	
	if Global.current_quest.milk != selected_milk:
		print("wrong milk")
		print(selected_milk)
		print(Global.current_quest.milk)
		return false
	
	if Global.current_quest.bubble != selected_bubble:
		print("wrong bublbe")
		print(selected_bubble)
		print(Global.current_quest.bubble)
		return false
	
	var extras_valid_count: int = 1
	
	for extras: ItemData.Type in selected_extras:
		if extras in Global.current_quest.extras:
			print(extras)
			extras_valid_count += 1
	
	if extras_valid_count != Global.current_quest.extras.size() - 1:
		print("wrong extras")
		print(extras_valid_count)
		print(Global.current_quest.extras, " / ", selected_extras)
		return false
	
	return true


func reset() -> void:
	selected_tea = ItemData.Type.GENERIC_ITEM
	selected_milk = ItemData.Type.GENERIC_ITEM
	selected_bubble = ItemData.Type.GENERIC_ITEM
	selected_extras.clear()
	
	LayerTea.texture = null
	LayerMilk.texture = null
	LayerBubbles.texture = null
	
	for child: Node in PanelExtrasLayers.get_children():
		child.queue_free()
	
	for child: Node in PanelExtrasLayersBack.get_children():
		child.queue_free()
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_item_dropped_in_cup(item: Item) -> void:
	print("Item: %s, dropped on cup: %s" % [item, item.data.type])
	
	var extras_textures: Array[Texture2D]
	
	match item.data.type:
		ItemData.Type.TEA_BLACK, ItemData.Type.TEA_GREEN, ItemData.Type.TEA_OOLONG:
			selected_tea = item.data.type
			LayerTea.texture = item.data.cup_texture
			
		ItemData.Type.BOBA_TAPIOCA, ItemData.Type.BOBA_POPPING, ItemData.Type.BOBA_SERAPHIC:
			selected_bubble = item.data.type
			LayerBubbles.texture = item.data.cup_texture
		
		ItemData.Type.MILK_DIARY, ItemData.Type.MILK_ALMOND, ItemData.Type.MILK_SUCCUBUS:
			selected_milk = item.data.type
			LayerMilk.texture = item.data.cup_texture
		
		ItemData.Type.EXTRAS_ICE, ItemData.Type.EXTRAS_SUGAR, ItemData.Type.EXTRAS_FRUIT_PIECES, ItemData.Type.EXTRAS_FRUIT_SYRUP:
			if not item.data.type in selected_extras:
				selected_extras.append(item.data.type)
				extras_textures.append(item.data.cup_texture)
		
		ItemData.Type.EXTRAS_SWEETENER, ItemData.Type.EXTRAS_TEARS, ItemData.Type.EXTRAS_BLOOD:
			if not item.data.type in selected_extras:
				selected_extras.append(item.data.type)
				extras_textures.append(item.data.cup_texture)
	
	for cup_texture: Texture2D in extras_textures:
		var texture_name: String = String(cup_texture.resource_path.get_file().get_slice(".", 0))
		
		if PanelExtrasLayers.has_node(texture_name) or PanelExtrasLayersBack.has_node(texture_name):
			continue
		
		var texture_rect: TextureRect = TextureRect.new()
		
		texture_rect.name = StringName(texture_name)
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		texture_rect.texture = cup_texture
		
		match texture_name:
			"Blood Texture", "Tear Texture", "Syrup texture": PanelExtrasLayersBack.add_child(texture_rect)
			_: PanelExtrasLayers.add_child(texture_rect)


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
