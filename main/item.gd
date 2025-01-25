#@tool
class_name Item
extends TextureRect

#region Signals
signal dropped
#endregion

#region Enums
#endregion

#region Constants
#endregion

#region Export Variables
@export var title: String
@export_multiline var description: String
#endregion

#region Public Variables
var is_pressed: bool: set = _set_is_pressed
var initial_position: Vector2

var parent: Control
var cup: Cup
#endregion

#region Private Variables
#endregion

#region OnReady Variables
@onready var PanelTooltip := %PanelTooltip as PanelContainer
@onready var VBoxTooltip := %VBoxTooltip as VBoxContainer
@onready var LabelTitle := %LabelTitle as Label
@onready var LabelDescription := %LabelDescription as Label
#endregion

#region Virtual Methods
func _ready() -> void:
	set_physics_process(false)
	gui_input.connect(_on_gui_input)
	
	LabelTitle.text = title
	LabelDescription.text = description
	
	get_window().size_changed.connect(_on_window_size_changed)
	
	for _signal: Signal in [mouse_entered, mouse_exited]:
		_signal.connect(_on_mouse_detection.bind(_signal == mouse_entered))
	
	await get_tree().process_frame
	
	initial_position = global_position
	parent = get_parent() as Control
	cup = get_tree().get_nodes_in_group(Cup.GROUP)[0] as Cup


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		
		if not mouse_button_event.pressed:
			match mouse_button_event.button_index:
				MOUSE_BUTTON_LEFT:
					is_pressed = false


func _physics_process(_delta: float) -> void:
	global_position = global_position.lerp(get_global_mouse_position() - size / 2.0, 0.25)
#endregion

#region Public Methods
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
					is_pressed = true
					PanelTooltip.visible = false
		
		else:
			match mouse_button_event.button_index:
				MOUSE_BUTTON_LEFT:
					if cup.get_global_rect().has_point(get_global_mouse_position()):
						var tween: Tween = create_tween()
						
						tween.tween_property(self, ^"global_position", initial_position, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
						dropped.emit()
					
					else:
						var viewport_size: Vector2 = get_viewport_rect().size
						
						global_position.x = clampf(global_position.x, 0.0, viewport_size.x - size.x)
						global_position.y = clampf(global_position.y, parent.global_position.y, viewport_size.y - size.y)
						
						initial_position = global_position


func _on_mouse_detection(entered: bool) -> void:
	if entered and not is_pressed:
		PanelTooltip.visible = true
		
		await get_tree().process_frame
		
		var mouse_position: Vector2 = get_global_mouse_position()
		var viewport_size: Vector2 = get_viewport_rect().size
		
		PanelTooltip.global_position.x = clampf(mouse_position.x, size.x, viewport_size.x - PanelTooltip.size.x)
		PanelTooltip.global_position.y = clampf(mouse_position.y, size.y, viewport_size.y - PanelTooltip.size.y)
		
		return
	
	PanelTooltip.visible = false
#endregion

#region SubClasses
#endregion

#region Setter Methods
func _set_is_pressed(arg: bool) -> void:
	is_pressed = arg
	set_physics_process(arg)
#endregion

#region Getter Methods
#endregion
