#@tool
class_name ItemData
extends Resource

#region Signals
#endregion

#region Enums
enum Type {
	GENERIC_ITEM,
	BOBA_TAPIOCA, BOBA_POPPING, BOBA_SERAPHIC,
	TEA_BLACK, TEA_GREEN, TEA_OOLONG,
	MILK_DIARY, MILK_ALMOND, MILK_SUCCUBUS,
	EXTRAS_ICE, EXTRAS_SUGAR, EXTRAS_SWEETENER, EXTRAS_FRUIT_SYRUP, EXTRAS_FRUIT_PIECES, EXTRAS_TEARS, EXTRAS_BLOOD,
	}
#endregion

#region Constants
const TEXTURES: Dictionary[Type, Texture2D] = {
	Type.BOBA_TAPIOCA: preload("res://Assets/Items/Tapioca Pearls.png"),
	Type.BOBA_POPPING: preload("res://Assets/Items/Blue Popping.png"),
	Type.BOBA_SERAPHIC: preload("res://Assets/Items/Brown Popping.png"),
	Type.TEA_BLACK: preload("res://Assets/Items/Black tea.png"),
	Type.TEA_GREEN: preload("res://Assets/Items/Green tea.png"),
	Type.TEA_OOLONG: preload("res://Assets/Items/Oolong tea.png"),
	Type.MILK_DIARY: preload("res://Assets/Items/Regular milk.png"),
	Type.MILK_ALMOND: preload("res://Assets/Items/Almond milk.png"),
	Type.MILK_SUCCUBUS: preload("res://Assets/Items/Sucubus.png"),
	Type.EXTRAS_ICE: preload("res://Assets/Items/Ice.png"),
	Type.EXTRAS_SUGAR: preload("res://Assets/Items/Sugar.png"),
	Type.EXTRAS_SWEETENER: preload("res://Assets/Items/Sweetener.png"),
	Type.EXTRAS_FRUIT_SYRUP: preload("res://Assets/Items/Fruits.png"),
	Type.EXTRAS_FRUIT_PIECES: preload("res://Assets/Items/Fruits.png"),
	Type.EXTRAS_TEARS: preload("res://Assets/Items/Tears.png"),
	Type.EXTRAS_BLOOD: preload("res://Assets/Items/Blood.png"),
}
#endregion

#region Export Variables
@export var type: Type = Type.GENERIC_ITEM
@export var item_texture: Texture2D
@export var cup_texture: Texture2D
@export var title: String
@export_multiline var description: String
@export var item_modulate: Color = Color.WHITE
@export var cup_modulate: Color = Color.WHITE
@export_file var sound_grab: String = 'res://Assets/Sounds/Item/item_select.wav'
@export_file var sound_drop_on_cup : String
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
