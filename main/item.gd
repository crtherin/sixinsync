@tool
class_name Item
extends TextureRect

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const GROUP: StringName = &"item"
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
@onready var PanelTooltip := %PanelTooltip as PanelContainer
@onready var VBoxTooltip := %VBoxTooltip as VBoxContainer
@onready var LabelTitle := %LabelTitle as Label
@onready var LabelDescription := %LabelDescription as Label
@onready var audioPlayer := $AudioStreamPlayer2D as AudioStreamPlayer2D
#endregion

#region Virtual Methods
func _ready() -> void:
	if data == null:
		return
	
	texture = data.item_texture
	modulate = data.item_modulate
	LabelTitle.text = data.title
	LabelDescription.text = data.description
	
	grab_stream = load(data.sound_grab)
	drop_on_cup_stream = load(data.sound_drop_on_cup)
	
	if Engine.is_editor_hint():
		return
	
	add_to_group(GROUP)
	gui_input.connect(_on_gui_input)
	
	get_window().size_changed.connect(_on_window_size_changed)
	
	for _signal: Signal in [mouse_entered, mouse_exited]:
		_signal.connect(_on_mouse_detection.bind(_signal == mouse_entered))
	
	for __: int in 2:
		await get_tree().process_frame
	
	set_random_position()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		
		if not mouse_button_event.pressed:
			match mouse_button_event.button_index:
				MOUSE_BUTTON_LEFT:
					is_pressed = false


func _physics_process(_delta: float) -> void:
	if is_pressed and not Engine.is_editor_hint():
		global_position = global_position.lerp(get_global_mouse_position() - size / 2.0, 0.25)
#endregion

#region Public Methods
func bring_to_front() -> void:
	Array(get_tree().get_nodes_in_group(GROUP), TYPE_OBJECT, &"TextureRect", Item).map(func(item: Item) -> void: item.z_index = 2 if item == self else 1)


func set_random_position() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	
	global_position.x = randf_range(0.0, viewport_size.x - size.x - panel_trash.size.x)
	global_position.y = randf_range(parent.global_position.y, viewport_size.y - size.y)
	
	initial_position = global_position
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_window_size_changed() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	
	var viewport_size: Vector2 = get_viewport_rect().size
	
	global_position.x = clampf(global_position.x, 0.0, viewport_size.x - size.x)
	global_position.y = clampf(global_position.y, 0.0, viewport_size.y - size.y)
	
	initial_position = global_position


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		
		if mouse_button_event.pressed:
			match mouse_button_event.button_index:
				MOUSE_BUTTON_LEFT:
					bring_to_front()
					
					create_tween().tween_property(self, ^"rotation", randf_range(-0.75, 0.75), 0.25)
					audioPlayer.set_stream(grab_stream)
					audioPlayer.play()
					is_pressed = true
					PanelTooltip.visible = false
					Global.item_is_dragging = true
					
					Input.set_custom_mouse_cursor(Global.CURSOR_CLOSED)
		
		else:
			match mouse_button_event.button_index:
				MOUSE_BUTTON_LEFT:
					if cup.get_global_rect().has_point(get_global_mouse_position()):
						Global.item_dropped_in_cup.emit(self)
						audioPlayer.set_stream(drop_on_cup_stream)
						audioPlayer.play()
					
					var viewport_size: Vector2 = get_viewport_rect().size
					var new_position: Vector2 = global_position
					var tween: Tween = create_tween()
					
					new_position.x = clampf(new_position.x, 0.0, viewport_size.x - size.x)
					new_position.y = clampf(new_position.y, parent.global_position.y, viewport_size.y - size.y)
					
					tween.tween_property(self, ^"global_position", new_position, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
					tween.parallel().tween_property(self, ^"rotation", 0.0, 0.25)
					
					initial_position = new_position
					Global.item_is_dragging = false
					
					Input.set_custom_mouse_cursor(Global.CURSOR_OPEN)


func _on_mouse_detection(entered: bool) -> void:
	var tween: Tween = create_tween()
	
	if entered and not is_pressed:
		PanelTooltip.modulate.a = 0.0
		PanelTooltip.visible = true
		
		tween.tween_property(PanelTooltip, ^"modulate:a", 1.0, 0.25)
		bring_to_front()
		
		await get_tree().process_frame
		
		var mouse_position: Vector2 = get_global_mouse_position()
		var viewport_size: Vector2 = get_viewport_rect().size
		
		PanelTooltip.global_position.x = clampf(mouse_position.x, size.x, viewport_size.x - PanelTooltip.size.x)
		PanelTooltip.global_position.y = clampf(mouse_position.y - 150.0, size.y, viewport_size.y - PanelTooltip.size.y)
		
		return
	
	tween.tween_property(PanelTooltip, ^"modulate:a", 0.0, 0.25)
	tween.tween_callback(PanelTooltip.hide)
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
