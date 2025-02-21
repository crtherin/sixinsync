#@tool
#class_name Global
extends Node

#region Signals
# Ignore the `unused_signal` warning from the project settings
signal item_dropped_in_cup(item: Item)
signal cup_dropped_on_customer(state: bool)

signal gold_changed(amount: int)

signal charon_requested
signal pause_requested
signal next_customer_requested
#endregion

#region Enums
enum MainSceneType {START_INTRO, START_MENU, GAME, END_DEFEAT, END_VICTORY, CREDITS}
#endregion

#region Constants
# Main scenes
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

# Game session
const TIMER_BOUNDS: Vector2 = Vector2(30.0, 60.0)
const EXTRAS_COUNT_BOUNDS: Vector2i = Vector2i(0, 3)
const CHARON_ROUND_BOUNDS: Vector2i = Vector2i(3, 5)
const CHARON_TAX_TOTAL_BOUNDS: Vector2i = Vector2i(15, 20)
#endregion

#region Export Variables
#endregion

#region Public Variables
# Current game session variables
var is_paused: bool
var is_grabbing_item: bool
var is_grabbing_cup: bool

var gold: int
var gold_to_receive: int

var charon_round: int
var charon_tax_total: int
var charon_event_counter: int

var timer: Timer

var current_order: Order
var current_customer: Customer
var current_time_interval: float
var current_round: int

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
	# Ignore the paused state in this script
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Set the timer node
	timer = Timer.new()
	timer.one_shot = true
	timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	add_child(timer)
	
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
	reset_game_session()
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
	
	match type:
		MainSceneType.GAME: reset_game_session()
	
	_current_main_scene = main_scene_pack.instantiate() as MainScene
	startup_scene.add_child(_current_main_scene)


func reset_game_session() -> void:
	get_tree().paused = false
	
	is_paused = false
	is_grabbing_item = false
	is_grabbing_cup = false
	
	gold = 0
	gold_to_receive = 0
	
	charon_round = 0
	charon_tax_total = 0
	charon_event_counter = 0
	
	timer.stop()
	
	current_order = null
	current_customer = null
	current_round = 0


func reset_charon_round() -> void:
	charon_round = randi_range(CHARON_ROUND_BOUNDS.x, CHARON_ROUND_BOUNDS.y)


func adjust_gold(value: int) -> void:
	gold += value
	gold_changed.emit(value)
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
