#@tool
class_name HoverPanel
extends PanelContainer

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const GROUP: StringName = &"hover_panel"

const TWEEN_MODULATE_VALLUE: float = 2.0
const TWEEN_MODULATE_SPEED: float = 0.25
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
	
	mouse_entered.connect(_on_mouse_entered)
#endregion

#region Public Methods
func set_hovered(state: bool) -> void:
	var tween: Tween = create_tween()
	var modulate_value: float = TWEEN_MODULATE_VALLUE if state else 1.0
	
	tween.tween_property(self, ^"self_modulate:v", modulate_value, TWEEN_MODULATE_SPEED)
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_mouse_entered() -> void:
	var all_hover_panels: Array[HoverPanel]
	
	get_tree().get_nodes_in_group(GROUP).map(func(node: Node) -> void:
		all_hover_panels.append(node as HoverPanel)
		)
	
	all_hover_panels.map(func(panel: HoverPanel) -> void:
		panel.set_hovered(panel == self)
		)
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
