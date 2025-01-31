#@tool
class_name Cup
extends PanelContainer

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const GROUP: StringName = &"cup_node"

const MOVE_SMOOTHING_WEIGHT: float = 0.1

const TWEEN_REPOSITION_SPEED: float = 0.25
const TWEEN_SCALE_MIN_OFFSET: float = 0.5
const TWEEN_SCALE_SPEED: float = 0.15
const TWEEN_MODULATE_SPEED: float = 0.15
#endregion

#region Export Variables
@export var panel_customer: PanelContainer
@export var panel_trash: ToolTrash
#endregion

#region Public Variables
var is_pressed: bool: set = _set_pressed
var initial_position: Vector2

var selected_tea: ItemData.Type
var selected_milk: ItemData.Type
var selected_boba: ItemData.Type
var selected_extras: Array[ItemData.Type]
#endregion

#region Private Variables
#endregion

#region OnReady Variables
# Layers
@onready var LayerMilk := %LayerMilk as TextureRect
@onready var LayerTea := %LayerTea as TextureRect
@onready var LayerBoba := %LayerBoba as TextureRect
@onready var PanelExtrasLayersBack := %PanelExtrasLayersBack as PanelContainer
@onready var LayerCup := %LayerCup as TextureRect
@onready var PanelExtrasLayersFront := %PanelExtrasLayersFront as PanelContainer

# Vfx
@onready var VBoxVfx := %VBoxVfx as VBoxContainer
@onready var VfxPadding := %VfxPadding as Control
@onready var VfxSplash := %VfxSplash as Splash
@onready var VfxOrderDone := %VfxOrderDone as Splash
@onready var VfxOrderFail := %VfxOrderFail as Splash
#endregion

#region Virtual Methods
func _ready() -> void:
	# Defaults
	add_to_group(GROUP)
	
	# Connections
	Global.item_dropped_in_cup.connect(_on_item_dropped_in_cup)
	gui_input.connect(_on_gui_input)
	get_window().size_changed.connect(_on_window_size_changed)
	
	# Wait two frames and register the current initial position
	for __: int in 2:
		await get_tree().process_frame
	
	_on_window_size_changed()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		
		if not mouse_button_event.pressed and is_pressed:
			match mouse_button_event.button_index:
				MOUSE_BUTTON_LEFT:
					# Reset the current position on mouse button release
					var mouse_position: Vector2 = get_global_mouse_position()
					var tween: Tween = create_tween()
					var tweener: PropertyTweener = tween.tween_property(
						self, ^"global_position", initial_position, TWEEN_REPOSITION_SPEED
						)
					
					tweener.set_ease(Tween.EASE_OUT)
					tweener.set_trans(Tween.TRANS_BACK)
					
					# Fade-in the background gradient
					tween.parallel().tween_property(
						self, ^"self_modulate", Color.WHITE, TWEEN_MODULATE_SPEED
						)
					
					# Check if the cup is dropped on the customer
					if panel_customer.get_global_rect().has_point(mouse_position):
						if Global.current_order == null:
							is_pressed = false
							return
						
						var selection_is_ok: bool = Global.current_order.check_validity(
							selected_tea, selected_milk, selected_boba, selected_extras
						)
						
						Global.cup_dropped_on_customer.emit(selection_is_ok)
						
						if selection_is_ok:
							VfxOrderDone.play()
							reset()
						
						else:
							VfxOrderFail.play()
					
					# Check if the cup is dropped on the trash
					elif panel_trash.get_global_rect().has_point(mouse_position):
						Global.gold_to_receive = 0
						reset()
					
					# Local updates
					is_pressed = false

# Movement smoothing
func _physics_process(_delta: float) -> void:
	if is_pressed:
		var final_position: Vector2 = get_global_mouse_position() - (size * scale) / 2.0
		
		global_position = global_position.lerp(final_position, MOVE_SMOOTHING_WEIGHT)
#endregion

#region Public Methods
func reset() -> void:
	selected_tea = ItemData.Type.NONE
	selected_milk = ItemData.Type.NONE
	selected_boba = ItemData.Type.NONE
	selected_extras.clear()
	
	LayerTea.texture = null
	LayerMilk.texture = null
	LayerBoba.texture = null
	
	for child: Node in PanelExtrasLayersBack.get_children():
		child.queue_free()
	
	for child: Node in PanelExtrasLayersFront.get_children():
		child.queue_free()
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_item_dropped_in_cup(item: Item) -> void:
	print("Item dropped on cup: %s" % item)
	
	VfxSplash.play()
	
	# Store the extras textures in this cache to apply them later on dynamically-created nodes
	var extras_textures_cache: Array[Texture2D]
	
	# Apply the matching layer texture based on the item type
	match item.data.type:
		# Tea types
		ItemData.Type.TEA_BLACK, ItemData.Type.TEA_GREEN, ItemData.Type.TEA_OOLONG:
			selected_tea = item.data.type
			LayerTea.texture = item.data.cup_texture
			
		# Boba types
		ItemData.Type.BOBA_TAPIOCA, ItemData.Type.BOBA_POPPING, ItemData.Type.BOBA_SERAPHIC:
			selected_boba = item.data.type
			LayerBoba.texture = item.data.cup_texture
		
		# Milk types
		ItemData.Type.MILK_DIARY, ItemData.Type.MILK_ALMOND, ItemData.Type.MILK_SUCCUBUS:
			selected_milk = item.data.type
			LayerMilk.texture = item.data.cup_texture
		
		# Extras types
		ItemData.Type.EXTRAS_ICE, ItemData.Type.EXTRAS_SUGAR, \
		ItemData.Type.EXTRAS_FRUIT_PIECES, ItemData.Type.EXTRAS_FRUIT_SYRUP, \
		ItemData.Type.EXTRAS_SWEETENER, ItemData.Type.EXTRAS_TEARS, ItemData.Type.EXTRAS_BLOOD:
			if not item.data.type in selected_extras:
				selected_extras.append(item.data.type)
				extras_textures_cache.append(item.data.cup_texture)
	
	# Create the extras layers if they don't exist and apply the cached textures
	for extras_texture: Texture2D in extras_textures_cache:
		var texture_name: String = String(extras_texture.resource_path.get_file().get_slice(".", 0))
		var parent_panel: PanelContainer = (
			PanelExtrasLayersFront if item.data.cup_texture_show_above else PanelExtrasLayersBack
			)
		
		if parent_panel.has_node(texture_name):
			continue
		
		var texture_rect: TextureRect = TextureRect.new()
		
		texture_rect.name = StringName(texture_name)
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		texture_rect.texture = extras_texture
		
		parent_panel.add_child(texture_rect)
	
	# Increment the global gold to receive counter based on the item data value
	Global.gold_to_receive += item.data.value

# Consider the cup grabbed only if this node is clicked
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		
		if mouse_button_event.pressed:
			match mouse_button_event.button_index:
				MOUSE_BUTTON_LEFT:
					is_pressed = true
					
					# Fade-out the background gradient
					create_tween().tween_property(
						self, ^"self_modulate", Color.TRANSPARENT, TWEEN_MODULATE_SPEED
						)

# Prevent the cup position t ogo out-of-bounds on window resizing
# and reset the pivot offset to the center (it can get resized)
func _on_window_size_changed() -> void:
	for __: int in 2:
		await get_tree().process_frame
	
	var viewport_size: Vector2 = get_viewport_rect().size
	
	global_position.x = clampf(global_position.x, 0.0, viewport_size.x - size.x)
	global_position.y = clampf(global_position.y, 0.0, viewport_size.y - size.y)
	pivot_offset = size / 2.0
	
	initial_position = global_position
#endregion

#region SubClasses
#endregion

#region Setter Methods
# Animate the scale on grabbing / dropping the cup
func _set_pressed(arg: bool) -> void:
	is_pressed = arg
	
	var scale_offset: float = TWEEN_SCALE_MIN_OFFSET if is_pressed else 1.0
	var ease_type: Tween.EaseType = Tween.EASE_IN if is_pressed else Tween.EASE_OUT
	
	var tween: Tween = create_tween()
	var tweener: PropertyTweener = tween.tween_property(
		self, ^"scale", Vector2.ONE * scale_offset, TWEEN_SCALE_SPEED
	)
	
	tweener.set_ease(ease_type)
	tweener.set_trans(Tween.TRANS_BACK)
	
	Global.is_grabbing_cup = is_pressed
#endregion

#region Getter Methods
#endregion
