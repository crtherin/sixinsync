#@tool
class_name ToolTrash
extends TextureRect

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const TEXTURE_OPENED: Texture2D = preload("res://Assets/TrashCan/Cos_deschis_V2.png")
const TEXTURE_CLOSED: Texture2D = preload("res://Assets/TrashCan/Cos_Inchis_V2.png")
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
	# Defaults
	set_physics_process(false)
	
	texture = TEXTURE_CLOSED
	
	for __: int in 2:
		await get_tree().process_frame
	
	pivot_offset = size / 2.0
	
	set_physics_process(true)


func _physics_process(_delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	var is_hovering: bool = Global.is_grabbing_cup or Global.is_grabbing_item
	var final_state: bool = is_hovering and get_global_rect().has_point(mouse_position)
	
	texture = TEXTURE_OPENED if final_state else TEXTURE_CLOSED
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
