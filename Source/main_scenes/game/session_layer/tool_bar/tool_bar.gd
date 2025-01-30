#@tool
class_name ToolBar
extends MarginContainer

#region Signals
#endregion

#region Enums
#endregion

#region Constants
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
#endregion

#region OnReady Variables
@onready var HFlowBackground := %HFlowBackground as HFlowContainer
@onready var ButtonMenu := %ButtonMenu as Button
#endregion

#region Virtual Methods
func _ready() -> void:
	for button: Button in [ButtonMenu]:
		button.pressed.connect(_on_button_pressed.bind(button))
#endregion

#region Public Methods
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_button_pressed(button: Button) -> void:
	match button:
		ButtonMenu:
			Global.pause_requested.emit()
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
