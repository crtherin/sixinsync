#@tool
#class_name Global
extends Node

#region Signals
# Ignore the `unused_signal` warning from the project settings

signal item_dropped_in_cup(item: Item)
signal cup_dropped_on_customer(state: bool)
signal cup_dropped_on_trash
signal warning_message_requested(text: String)
signal game_start
signal game_over
signal time_out
signal gold_change(amount: int)
signal charon()
#endregion

#region Enums
#endregion

#region Constants
# Assets
const CURSOR_OPEN: Texture2D = preload("res://Assets/Cursor/Hand_Open.png")
const CURSOR_CLOSED: Texture2D = preload("res://Assets/Cursor/Hand_Closed.png")

# Texts
const TEXTS_CUSTOMERS: String = "res://Assets/Text/dialogues.json"
const TEXTS_CHARON: String = "res://Assets/Text/charon.json"
#endregion

#region Export Variables
#endregion

#region Public Variables
var is_paused: bool
var gold: int
var charon_tax_total: int
var customer_done: bool
var current_quest: Dictionary = {
	"tea": -1,
	"milk": -1,
	"bubble": -1,
	"extras": [],
}

var customers_data: Array[Dictionary]
var charon_data: Dictionary
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
func _ready():
	var file_customers: String = FileAccess.open(TEXTS_CUSTOMERS, FileAccess.READ).get_as_text()
	var file_charon: String = FileAccess.open(TEXTS_CHARON, FileAccess.READ).get_as_text()
	
	var parsed_customers: Variant = JSON.parse_string(file_customers)
	var parsed_charon: Variant = JSON.parse_string(file_charon)
	
	if parsed_customers == null or parsed_charon == null:
		push_error("Could not parse all json files!")
		return
	
	customers_data = Array(parsed_customers, TYPE_DICTIONARY, &"", null)
	charon_data = parsed_charon
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
