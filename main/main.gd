#@tool
class_name Main
extends Control

#region Signals
#endregion

#region Enums
#endregion

#region Constants
#endregion

#region Export Variables
#endregion

#region Public Variables
var customers_data: Array[Dictionary]
#endregion

#region Private Variables
var gameRunning = false

var customerLabel
var timerLabel
var goldLabel

var round_value : int = 0
var obolInCup: int = 0
var charonEventCounter : int = 0


var charonRound
var rand
#endregion

#region OnReady Variables
@onready var TimerGame := %TimerGame as Timer
@onready var PanelBackground := %PanelBackground as PanelContainer
@onready var MarginBackground := %MarginBackground as MarginContainer
@onready var VBoxBackground := %VBoxBackground as VBoxContainer
@onready var HBoxGameArea := %HBoxGameArea as HBoxContainer
@onready var PanelQuest := %PanelQuest as PanelContainer
@onready var MarginQuest := %MarginQuest as MarginContainer
@onready var PanelQuestBackground := %PanelQuestBackground as PanelContainer
@onready var MarginPanelQuestBackground := %MarginPanelQuestBackground as MarginContainer
@onready var VboxPanelQuestBackground := %VboxPanelQuestBackground as VBoxContainer
@onready var GridPanelQuestBackground := %GridPanelQuestBackground as GridContainer
@onready var LabelPanelQuestBackground := %LabelPanelQuestBackground as Label
@onready var PanelCup := %PanelCup as PanelContainer
@onready var MarginCup := %MarginCup as MarginContainer
@onready var CupRef := %CupRef as Cup
@onready var AspectRatioCup := %AspectRatioCup as AspectRatioContainer
@onready var VBoxCustomer := %VBoxCustomer as VBoxContainer
@onready var PanelStats := %PanelStats as PanelContainer
@onready var PanelCustomer := %PanelCustomer as PanelContainer
@onready var MarginCustomer := %MarginCustomer as MarginContainer
@onready var TextureCustomer := %TextureCustomer as TextureRect
@onready var PanelItems := %PanelItems as PanelContainer
@onready var ItemsContainer := %ItemsContainer as Control
@onready var PanelTrash := %PanelTrash as PanelContainer

@onready var MenuLayer := %MenuLayer as Menu
#endregion

#region Virtual Methods
func _ready() -> void:
	Input.set_custom_mouse_cursor(Global.CURSOR_OPEN)
	
	customers_data = Array(JSON.parse_string(FileAccess.open("res://Assets/Text/dialogues.json", FileAccess.READ).get_as_text()), TYPE_DICTIONARY, &"", null)
	customerLabel = get_node("PanelBackground/MarginBackground/VBoxBackground/TexureBackground/HBoxGameArea/VBoxCustomer/PanelCustomer/MarginCustomer/VBoxCustomer2/LabelPanelCustomer")
	timerLabel = get_node("PanelBackground/MarginBackground/VBoxBackground/TexureBackground/HBoxGameArea/VBoxCustomer/PanelStats/MarginStats/HBoxStats/TimerLabel")
	goldLabel = get_node("PanelBackground/MarginBackground/VBoxBackground/TexureBackground/HBoxGameArea/VBoxCustomer/PanelStats/MarginStats/HBoxStats/GoldLabel")
	
	Global.cup_dropped_on_customer.connect(_on_cup_dropped_on_customer)
	Global.cup_dropped_on_trash.connect(_on_cup_dropped_on_trash)
	Global.item_dropped_in_cup.connect(_on_item_dropped_in_cup)
	Global.gold_change.connect(_update_gold)
	Global.game_start.connect(_start_game)
	
	rand = RandomNumberGenerator.new()
	setCharonRound()
	
	showGold()
	
	
	#set_next_customer()

 	


func _process(_delta):
	if TimerGame.is_stopped() && gameRunning:
		Global.time_out.emit()
		round_value += 1
		
	var timeLeft = int(floor(TimerGame.get_time_left()))
	timerLabel.text = "Time left: " + str(timeLeft)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_input := event as InputEventKey
		
		if key_input.pressed:
			match key_input.keycode:
				KEY_Q: set_next_customer()
#endregion

#region Public Methods
func showGold():
	var current = Global.getGold()
	goldLabel.text = "Obol: " + str(current)
	
	
func set_next_customer() -> void:
	gameRunning = false
	TimerGame.stop()
	
	Global.current_quest.tea = [ItemData.Type.TEA_BLACK, ItemData.Type.TEA_GREEN, ItemData.Type.TEA_OOLONG].pick_random()
	Global.current_quest.milk = [ItemData.Type.MILK_DIARY, ItemData.Type.MILK_ALMOND, ItemData.Type.MILK_SUCCUBUS].pick_random()
	Global.current_quest.bubble = [ItemData.Type.BOBA_TAPIOCA, ItemData.Type.BOBA_POPPING, ItemData.Type.BOBA_SERAPHIC].pick_random()
	Global.current_quest.extras.clear()
	
	var extras: Array = [
		ItemData.Type.EXTRAS_ICE, ItemData.Type.EXTRAS_SUGAR, ItemData.Type.EXTRAS_SWEETENER, ItemData.Type.EXTRAS_FRUIT_SYRUP,
		ItemData.Type.EXTRAS_FRUIT_PIECES, ItemData.Type.EXTRAS_TEARS, ItemData.Type.EXTRAS_BLOOD
		]
	
	for __: int in randi_range(1, 3):
		Global.current_quest.extras.append(extras.pop_at(randi_range(1, extras.size() - 1)))
	
	for child: Node in GridPanelQuestBackground.get_children():
		child.queue_free()
	
	var all_required_types: Array = Global.current_quest.extras.duplicate()
	
	all_required_types.append(Global.current_quest.tea)
	all_required_types.append(Global.current_quest.milk)
	all_required_types.append(Global.current_quest.bubble)
	
	for type: ItemData.Type in all_required_types:
		var texture_rect: TextureRect = TextureRect.new()
		
		texture_rect.custom_minimum_size = Vector2.ONE * 120.0
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.texture = ItemData.TEXTURES[type]
		
		GridPanelQuestBackground.add_child(texture_rect)
	
	await get_tree().process_frame
	
	var customer_id: float = float(randi_range(2, 13))
	var customer_data: Dictionary
	
	for customer_data_entry: Dictionary in customers_data:
		if customer_data_entry.id == customer_id:
			customer_data = customer_data_entry
			break
	
	if customer_data.is_empty():
		push_error("Missing JSON data for id: %d" % customer_id)
		return
	
	TextureCustomer.texture = load(customer_data.icon)
	var line = customer_data.opening[randi_range(0,2)]
	LabelPanelQuestBackground.show_bubble(line)
	customerLabel.set_text(customer_data.description)
	
	
	TimerGame.start()
	gameRunning = true
	
	#Global.game_over.emit()
	#Global.charon_event()
	
	
	for item: Item in get_items():
		item.set_random_position()
	
	CupRef.reset()


func get_items() -> Array[Item]:
	var items: Array[Item]
	
	for child: Node in ItemsContainer.get_children():
		if child is Item:
			items.append(child as Item)
	
	return items
#endregion

#region Private Methods
func setCharonRound():
	charonRound = rand.randi_range(3,5)
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _start_game():
	set_next_customer()

func _update_gold(amount):
	Global.addGold(amount)
	showGold()

func _on_cup_dropped_on_customer(isOk: bool) -> void:
	print("Dropped on customer")
	print(isOk)
	
	if isOk:
		obolInCup+=(randi() % 4)
		update_counter(obolInCup)
		round_value += 1
		if (round_value % charonRound == 0):
			print("Charon came and took 100 gold!")
			charonEventCounter += 1
			Global.charonTaxTotal = ((charonEventCounter-1) * 2) + randi_range(12, 14)
			setCharonRound()
			Global.charon_event()
			Global.gold_change_event(Global.charonTaxTotal)
		else:
			set_next_customer()
				
	else: 
		Global.warning_message_event("Wrong BUBBLE TEA!")
	


func _on_cup_dropped_on_trash() -> void:
	obolInCup = 0
	print("Dropped on trash")
	
func _on_item_dropped_in_cup(item: Item) -> void:

	match item.data.type:
		ItemData.Type.TEA_BLACK, ItemData.Type.TEA_GREEN, ItemData.Type.BOBA_TAPIOCA, ItemData.Type.BOBA_POPPING, ItemData.Type.MILK_DIARY, ItemData.Type.MILK_ALMOND:
			obolInCup+=2
			
		ItemData.Type.BOBA_SERAPHIC, ItemData.Type.TEA_OOLONG, ItemData.Type.MILK_SUCCUBUS:
			obolInCup+=3
		
		ItemData.Type.EXTRAS_ICE, ItemData.Type.EXTRAS_SUGAR, ItemData.Type.EXTRAS_SWEETENER, ItemData.Type.EXTRAS_FRUIT_SYRUP, ItemData.Type.EXTRAS_FRUIT_PIECES, ItemData.Type.EXTRAS_FRUIT_PIECES, ItemData.Type.EXTRAS_TEARS, ItemData.Type.EXTRAS_BLOOD:
			obolInCup+=1

func update_counter(int) -> void:
	Global.gold_change_event(obolInCup)
	obolInCup=0
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
