@tool
class_name Item
extends TextureRect

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const GROUP: StringName = &"item"
const MOVE_SMOOTHING_WEIGHT: float = 0.25

const Z_INDEX_BACK: int = 1
const Z_INDEX_FRONT: int = 2

const TWEEN_ROTATION_LIMIT: float = 25.0 # In degrees
const TWEEN_ROTATION_SPEED: float = 0.25
const TWEEN_POSITION_SPEED: float = 0.5
const TWEEN_TOOLTIP_MODULATE_SPEED: float = 0.15

const TOOLTIP_VERTICAL_POSITION_OFFSET: float = 150.0
#endregion

#region Export Variables
@export var data: ItemData
@export var parent: Control
@export var cup: Cup
@export var panel_trash: PanelContainer
#endregion

#region Public Variables
var is_pressed: bool
var initial_position: Vector2

var grab_stream: AudioStreamWAV
var drop_on_cup_stream: AudioStreamWAV
#endregion

#region Private Variables
#endregion

#region OnReady Variables
@onready var AudioPlayer := $AudioPlayer as AudioStreamPlayer2D

# Tooltip
@onready var PanelTooltip := %PanelTooltip as PanelContainer
@onready var PanelTooltipCorners := %PanelTooltipCorners as PanelContainer
@onready var NinePatchTooltip := %NinePatchTooltip as NinePatchRect
@onready var MarginTooltip := %MarginTooltip as MarginContainer
@onready var VBoxTooltip := %VBoxTooltip as VBoxContainer
@onready var LabelTooltipTitle := %LabelTooltipTitle as Label
@onready var LabelTooltipDescription := %LabelTooltipDescription as Label
#endregion

#region Virtual Methods
func _ready() -> void:
	if data == null:
		push_error("No data resource was provided!")
		return
	
	# Apply data properties
	texture = data.item_texture
	modulate = data.item_modulate
	
	grab_stream = load(data.sound_grab)
	drop_on_cup_stream = load(data.sound_drop_on_cup)
	
	LabelTooltipTitle.text = data.title
	LabelTooltipDescription.text = data.description
	
	# Local updates
	if Engine.is_editor_hint():
		return
	
	add_to_group(GROUP)
	_hide_tooltip()
	
	# Signal connections
	gui_input.connect(_on_gui_input)
	get_window().size_changed.connect(_clamp_global_position)
	
	for _signal: Signal in [mouse_entered, mouse_exited]:
		_signal.connect(_on_mouse_detection.bind(_signal == mouse_entered))
	
	# Wait two frames before altering the transform values in `_ready`
	for __: int in 2:
		await get_tree().process_frame
	
	pivot_offset = custom_minimum_size / 2.0
	set_random_position()

# Set `is_pressed` to false from the global `_input` call to detach the item
# from the cursor if the cursor is not hovering over the item
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		
		if not mouse_button_event.pressed:
			match mouse_button_event.button_index:
				MOUSE_BUTTON_LEFT:
					# Calculate the initial position
					var limits_low: Vector2 = Vector2(0.0,  parent.global_position.y)
					var limits_high: Vector2 = _get_screen_limits()
					
					initial_position.x = clampf(global_position.x, limits_low.x, limits_high.x)
					initial_position.y = clampf(global_position.y, limits_low.y, limits_high.y)
					
					# Animate the position back to the initial point
					var tween: Tween = create_tween()
					var tweener_position: PropertyTweener = tween.tween_property(
						self, ^"global_position", initial_position, TWEEN_POSITION_SPEED
						)
					var tweener_rotation: PropertyTweener = tween.parallel().tween_property(
						self, ^"rotation", 0.0, TWEEN_ROTATION_SPEED
						)
					
					tweener_position.set_ease(Tween.EASE_OUT)
					tweener_position.set_trans(Tween.TRANS_BACK)
					
					tweener_rotation.set_ease(Tween.EASE_IN)
					tweener_rotation.set_trans(Tween.TRANS_SINE)
					
					# Update the mouse cursor
					Input.set_custom_mouse_cursor(Global.CURSOR_OPEN)
					
					# Local updates
					is_pressed = false

# Movement smoothing
func _physics_process(_delta: float) -> void:
	if is_pressed and not Engine.is_editor_hint():
		var final_position: Vector2 = (get_global_mouse_position() - custom_minimum_size / 2.0)
		
		global_position = global_position.lerp(final_position, MOVE_SMOOTHING_WEIGHT)
#endregion

#region Public Methods
func bring_to_front() -> void:
	var all_items := Array(
		get_tree().get_nodes_in_group(GROUP), TYPE_OBJECT, &"TextureRect", Item
		) as Array[Item]
	
	var func_lambda: Callable = func(item: Item) -> void:
		item.z_index = Z_INDEX_FRONT if item == self else Z_INDEX_BACK
	
	all_items.map(func_lambda)


func set_random_position() -> void:
	var random_position: Vector2 = get_random_position()
	
	global_position = random_position
	initial_position = random_position


func get_random_position() -> Vector2:
	var screen_limits: Vector2 = _get_screen_limits()
	
	return Vector2(
		randf_range(0.0, screen_limits.x),
		randf_range(parent.global_position.y, screen_limits.y)
		)
#endregion

#region Private Methods
func _clamp_global_position() -> void:
	for __: int in 2:
		await get_tree().process_frame
	
	var screen_limits: Vector2 = _get_screen_limits()
	
	global_position.x = clampf(global_position.x, 0.0, screen_limits.x)
	global_position.y = clampf(global_position.y, parent.global_position.y, screen_limits.y)
	
	initial_position = global_position


func _get_screen_limits() -> Vector2:
	var viewport_size: Vector2 = get_viewport_rect().size
	
	return Vector2(
		viewport_size.x - custom_minimum_size.x,
		viewport_size.y - custom_minimum_size.y
	)


func _hide_tooltip() -> void:
	PanelTooltip.visible = false
	PanelTooltip.modulate.a = 0.0
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		
		# On item grabbing
		if mouse_button_event.pressed:
			match mouse_button_event.button_index:
				MOUSE_BUTTON_LEFT:
					# Change the Z axis and wait a bit
					bring_to_front()
					await get_tree().process_frame
					
					# Animate the rotation
					var rotation_value: float = deg_to_rad(randf_range(
						-TWEEN_ROTATION_LIMIT, TWEEN_ROTATION_LIMIT
						))
					
					var tween: Tween = create_tween()
					var tweener_rotation: PropertyTweener = tween.tween_property(
						self, ^"rotation", rotation_value, TWEEN_ROTATION_SPEED
						)
					
					tweener_rotation.set_ease(Tween.EASE_IN)
					tweener_rotation.set_trans(Tween.TRANS_SINE)
					
					# Play the grab sound
					AudioPlayer.set_stream(grab_stream)
					AudioPlayer.play()
					
					# Update the mouse cursor
					Input.set_custom_mouse_cursor(Global.CURSOR_CLOSED)
					
					# Local updates
					_hide_tooltip()
					is_pressed = true
		
		else:
			match mouse_button_event.button_index:
				MOUSE_BUTTON_LEFT:
					# Check if the mouse cursor is above the cup rect
					if cup.get_global_rect().has_point(get_global_mouse_position()):
						Global.item_dropped_in_cup.emit(self)
						
						# Play the drop sound
						AudioPlayer.set_stream(drop_on_cup_stream)
						AudioPlayer.play()


func _on_mouse_detection(entered: bool) -> void:
	var tween: Tween = create_tween()
	
	# Make the tooltip visible on hover
	if entered and not is_pressed:
		# Set the modulate.a value to 0 before tweening it to 1 to avoid choppyness
		# Using .from(0.0) in the tweener is not an alternative
		PanelTooltip.modulate.a = 0.0
		PanelTooltip.visible = true
		
		tween.tween_property(PanelTooltip, ^"modulate:a", 1.0, TWEEN_TOOLTIP_MODULATE_SPEED)
		
		# Change the z axis between two dead frames
		bring_to_front.call_deferred()
		
		# Set the tooltip position above the mouse cursor
		# and clamp it to the edges of the viewport
		var mouse_position: Vector2 = get_global_mouse_position()
		var viewport_size: Vector2 = get_viewport_rect().size
		
		var tooltip_position: Vector2 = Vector2(
			mouse_position.x,
			mouse_position.y - TOOLTIP_VERTICAL_POSITION_OFFSET
			)
		var tooltip_position_limits: Vector2 = viewport_size - PanelTooltip.size
		
		PanelTooltip.global_position.x = clampf(tooltip_position.x, 0.0, tooltip_position_limits.x)
		PanelTooltip.global_position.y = clampf(tooltip_position.y, 0.0, tooltip_position_limits.y)
		
		return
	
	# Hide the tooltip
	tween.tween_property(PanelTooltip, ^"modulate:a", 0.0, TWEEN_TOOLTIP_MODULATE_SPEED)
	tween.tween_callback(_hide_tooltip)
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
