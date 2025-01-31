#@tool
class_name ItemData
extends Resource

#region Signals
#endregion

#region Enums
enum Type {
	NONE,
	
	# Boba Types
	BOBA_TAPIOCA, BOBA_POPPING, BOBA_SERAPHIC,
	
	# Tea Types
	TEA_BLACK, TEA_GREEN, TEA_OOLONG,
	
	# Milk Types
	MILK_DIARY, MILK_ALMOND, MILK_SUCCUBUS,
	
	# Extras Types
	EXTRAS_ICE, EXTRAS_SUGAR, EXTRAS_SWEETENER, EXTRAS_FRUIT_SYRUP,
	EXTRAS_FRUIT_PIECES, EXTRAS_TEARS, EXTRAS_BLOOD,
	}
#endregion

#region Constants
const DEFAULT_GRAB_SOUND_FILE_PATH: String = "res://Assets/Sounds/Item/item_select.wav"

const MAPPED_TEXTURES: Dictionary[Type, Texture2D] = {
	# Boba Textures
	Type.BOBA_TAPIOCA: preload("res://Assets/Items/BOB3.png"),
	Type.BOBA_POPPING: preload("res://Assets/Items/BOB1.png"),
	Type.BOBA_SERAPHIC: preload("res://Assets/Items/BOB2.png"),
	
	# Tea Textures
	Type.TEA_BLACK: preload("res://Assets/Items/Black tea.png"),
	Type.TEA_GREEN: preload("res://Assets/Items/Green tea.png"),
	Type.TEA_OOLONG: preload("res://Assets/Items/Oolong tea.png"),
	
	# Milk Textures
	Type.MILK_DIARY: preload("res://Assets/Items/Regular milk.png"),
	Type.MILK_ALMOND: preload("res://Assets/Items/Almond milk.png"),
	Type.MILK_SUCCUBUS: preload("res://Assets/Items/Sucubus.png"),
	
	# Extras Textures
	Type.EXTRAS_ICE: preload("res://Assets/Items/Ice.png"),
	Type.EXTRAS_SUGAR: preload("res://Assets/Items/Sugar.png"),
	Type.EXTRAS_SWEETENER: preload("res://Assets/Items/Sweetener.png"),
	Type.EXTRAS_FRUIT_SYRUP: preload("res://Assets/Items/Fruit SYrup.png"),
	Type.EXTRAS_FRUIT_PIECES: preload("res://Assets/Items/Fruits.png"),
	Type.EXTRAS_TEARS: preload("res://Assets/Items/Tears.png"),
	Type.EXTRAS_BLOOD: preload("res://Assets/Items/Blood.png"),
}

const ALL_BOBAS: Array[Type] = [Type.BOBA_TAPIOCA, Type.BOBA_POPPING, Type.BOBA_SERAPHIC]
const ALL_TEAS: Array[Type] = [Type.TEA_BLACK, Type.TEA_GREEN, Type.TEA_OOLONG]
const ALL_MILKS: Array[Type] = [Type.MILK_DIARY, Type.MILK_ALMOND, Type.MILK_SUCCUBUS]
const ALL_EXTRAS: Array[Type] = [
	Type.EXTRAS_ICE, Type.EXTRAS_SUGAR, Type.EXTRAS_SWEETENER, Type.EXTRAS_FRUIT_SYRUP,
	Type.EXTRAS_FRUIT_PIECES, Type.EXTRAS_TEARS, Type.EXTRAS_BLOOD,
	]
#endregion

#region Export Variables
# Generic
@export var type: Type = Type.NONE
@export var value: int

# Textures
@export var item_texture: Texture2D
@export var cup_texture: Texture2D
@export var cup_texture_show_above: bool

# Texts
@export var title: String
@export_multiline var description: String

# Modulates
@export var item_modulate: Color = Color.WHITE
@export var cup_modulate: Color = Color.WHITE

# Sounds
@export_file("*.wav") var sound_grab: String = DEFAULT_GRAB_SOUND_FILE_PATH
@export_file("*.wav") var sound_drop_on_cup: String
#endregion

#region Public Variables
#endregion

#region Private Variables
#endregion

#region OnReady Variables
#endregion

#region Virtual Methods
func _to_string() -> String:
	return "<ItemData[%s][%d]>" % [title, type]
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
