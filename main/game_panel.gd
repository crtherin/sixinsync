#@tool
class_name GamePanel
extends PanelContainer

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const GROUP: StringName = &"game_panel"
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
#endregion

#region OnReady Variables
#endregion

#region Virtual Methods
func _ready() -> void:
	add_to_group(GROUP)
	
	for _signal: Signal in [mouse_entered, mouse_exited]:
		_signal.connect(_on_mouse_detection.bind(_signal == mouse_entered))
#endregion

#region Public Methods
func set_hovered(state: bool) -> void:
	create_tween().tween_property(self, ^"self_modulate:v", 2.0 if state else 1.0, 0.25)
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_mouse_detection(entered: bool) -> void:
	if entered:
		Array(get_tree().get_nodes_in_group(GROUP), TYPE_OBJECT, &"PanelContainer", GamePanel).map(func(panel: GamePanel) -> void:
			panel.set_hovered(panel == self)
			)
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
