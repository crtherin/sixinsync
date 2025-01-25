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
	customers_data = Array(JSON.parse_string(FileAccess.open("res://Assets/Text/dialogues.txt", FileAccess.READ).get_as_text()), TYPE_DICTIONARY, &"", null)
	
	Global.cup_dropped_on_customer.connect(_on_cup_dropped_on_customer)
	Global.cup_dropped_on_trash.connect(_on_cup_dropped_on_trash)
	
	set_next_customer()

func _process(delta):
	if TimerGame.is_stopped() && gameRunning:
		Global.game_over.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_input := event as InputEventKey
		
		if key_input.pressed:
			match key_input.keycode:
				KEY_Q: set_next_customer()
#endregion

#region Public Methods
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
	
	var all_required_types: Array = Global.current_quest.extras
	
	all_required_types.append(Global.current_quest.tea)
	all_required_types.append(Global.current_quest.milk)
	all_required_types.append(Global.current_quest.bubble)
	
	for type: ItemData.Type in all_required_types:
		var texture_rect: TextureRect = TextureRect.new()
		
		texture_rect.custom_minimum_size = Vector2.ONE * 40.0
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
	LabelPanelQuestBackground.text = customer_data.opening[0]
	
	TimerGame.start()
	gameRunning = true
	


func get_items() -> Array[Item]:
	return Array(ItemsContainer.get_children(), TYPE_OBJECT, &"TextureRect", Item)
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_cup_dropped_on_customer() -> void:
	print("Dropped on customer")


func _on_cup_dropped_on_trash() -> void:
	print("Dropped on trash")
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
