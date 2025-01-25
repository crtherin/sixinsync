#@tool
class_name ItemData
extends Resource

#region Signals
#endregion

#region Enums
enum Type {
	GENERIC_ITEM,
	BOBA_TAPIOCA, BOBA_POPPING,
	TEA_BLACK, TEA_GREEN, TEA_OOLONG,
	MILK_DIARY, MILK_ALMOND, MILK_SUCCUBUS,
	EXTRAS_ICE, EXTRAS_SUGAR, EXTRAS_SWEETENER, EXTRAS_FRUIT_SYRUP, EXTRAS_FRUIT_PIECES, EXTRAS_TEARS, EXTRAS_BLOOD,
	}
#endregion

#region Constants
#endregion

#region Export Variables
@export var type: Type = Type.GENERIC_ITEM
@export var texture: Texture2D
@export var title: String
@export_multiline var description: String
@export var modulate: Color = Color.WHITE
#endregion

#region Public Variables
#endregion

#region Private Variables
#endregion

#region OnReady Variables
#endregion

#region Virtual Methods
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
