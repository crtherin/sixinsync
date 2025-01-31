#@tool
class_name EndDefeat
extends MainScene

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const TWEEN_MODULATE_SPEED: float = 2.0
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
#endregion

#region OnReady Variables
@onready var TextureBackground := %TextureBackground as TextureRect
@onready var PanelVignette := %PanelVignette as PanelContainer
@onready var VBoxBackground := %VBoxBackground as VBoxContainer
@onready var LabelTitle := %LabelTitle as Label
@onready var LabelDescription := %LabelDescription as Label
@onready var ButtonConfirm := %ButtonConfirm as GameButton
#endregion

#region Virtual Methods
func _ready() -> void:
	# Defaults
	process_mode = Node.PROCESS_MODE_ALWAYS
	VBoxBackground.modulate.a = 0.0
	
	# Connections
	ButtonConfirm.pressed.connect(func() -> void:
		Global.change_main_scene(Global.MainSceneType.START_MENU)
		)
	
	# Animate
	create_tween().tween_property(VBoxBackground, ^"modulate:a", 1.0, TWEEN_MODULATE_SPEED)
#endregion

#region Public Methods
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
