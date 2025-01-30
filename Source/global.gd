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
signal charon
#endregion

#region Enums
enum MainSceneType {START_INTRO, START_MENU, GAME, END_DEFEAT, END_VICTORY, CREDITS}
#endregion

#region Constants
const DEFAULT_MAIN_SCENE_TYPE: MainSceneType = MainSceneType.START_INTRO
const MAPPED_MAIN_SCENE_PACKS: Dictionary[MainSceneType, PackedScene] = {
	MainSceneType.START_INTRO: preload("res://Source/main_scenes/start_intro/start_intro.tscn"),
	MainSceneType.START_MENU: preload("res://Source/main_scenes/start_menu/start_menu.tscn"),
	MainSceneType.GAME: preload("res://Source/main_scenes/game/game.tscn"),
	MainSceneType.END_DEFEAT: preload("res://Source/main_scenes/end_defeat/end_defeat.tscn"),
	MainSceneType.END_VICTORY: preload("res://Source/main_scenes/end_victory/end_victory.tscn"),
	MainSceneType.CREDITS: preload("res://Source/main_scenes/credits/credits.tscn"),
}

# Assets
const CURSOR_OPEN: Texture2D = preload("res://Assets/Cursor/Hand_Open.png")
const CURSOR_CLOSED: Texture2D = preload("res://Assets/Cursor/Hand_Closed.png")

# Texts
const TEXTS_CUSTOMERS: String = "res://Assets/Text/dialogues.json"
const TEXTS_CHARON: String = "res://Assets/Text/charon.json"
const TEXTS_CREDITS: String = "res://Assets/Text/credits.json"
#endregion

#region Export Variables
#endregion

#region Public Variables
# Current game session variables
var is_paused: bool
var gold: int
var charon_tax_total: int
var current_order: Order

# Parsed JSON data
var customers_data: Array[Dictionary]
var charon_data: Dictionary
var credits_data: Array
#endregion

#region Private Variables
var _current_main_scene: MainScene
#endregion

#region OnReady Variables
@onready var startup_scene: Node = get_tree().current_scene
#endregion

#region Virtual Methods
func _ready():
	# Parse and store the JSON files
	var file_customers: String = FileAccess.open(TEXTS_CUSTOMERS, FileAccess.READ).get_as_text()
	var file_charon: String = FileAccess.open(TEXTS_CHARON, FileAccess.READ).get_as_text()
	var file_credits: String = FileAccess.open(TEXTS_CREDITS, FileAccess.READ).get_as_text()
	
	var parsed_customers: Variant = JSON.parse_string(file_customers)
	var parsed_charon: Variant = JSON.parse_string(file_charon)
	var parsed_credits: Variant = JSON.parse_string(file_credits)
	
	for parsed_data: Variant in [parsed_customers, parsed_charon, parsed_credits]:
		if parsed_data == null:
			push_error("One of the json files could not be parsed!")
			return
	
	customers_data = Array(parsed_customers, TYPE_DICTIONARY, &"", null)
	charon_data = parsed_charon
	credits_data = parsed_credits
	
	# Set the default main scene
	change_main_scene(DEFAULT_MAIN_SCENE_TYPE)
#endregion

#region Public Methods
func change_main_scene(type: MainSceneType) -> void:
	if _current_main_scene != null:
		_current_main_scene.queue_free()
		_current_main_scene = null
	
	var main_scene_pack: PackedScene = MAPPED_MAIN_SCENE_PACKS[type]
	
	if main_scene_pack == null:
		return
	
	_current_main_scene = main_scene_pack.instantiate() as MainScene
	startup_scene.add_child(_current_main_scene)


func reset_game_session() -> void:
	is_paused = false
	get_tree().paused = false
	
	gold = 0
	charon_tax_total = 0
	
	current_order = null
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
