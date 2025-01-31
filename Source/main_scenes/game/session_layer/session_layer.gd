#@tool
class_name SessionLayer
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
#endregion

#region Private Variables
#endregion

#region OnReady Variables
# Audio
@onready var Ambiance := %Ambiance as Node

# Background
@onready var VBoxBackground := %VBoxBackground as VBoxContainer

# Top layer
@onready var PanelTopLayer := %PanelTopLayer as PanelContainer
@onready var TopLayerTextureRef := %TopLayerTextureRef as TopLayerTexture
@onready var VBoxTopLayerBackground := %VBoxTopLayerBackground as VBoxContainer
@onready var HBoxTopLayer := %HBoxTopLayer as HBoxContainer
@onready var VBoxTopLayerLeft := %VBoxTopLayerLeft as VBoxContainer
# -> ToolBar
@onready var PanelToolBar := %PanelToolBar as PanelContainer
@onready var ToolBarRef := %ToolBarRef as ToolBar
# -> Orders
@onready var PanelOrders := %PanelOrders as PanelContainer
@onready var OrdersMenuRef := %OrdersMenuRef as OrdersMenu
# -> Cup
@onready var PanelCup := %PanelCup as PanelContainer
@onready var AspectRatioCup := %AspectRatioCup as AspectRatioContainer
@onready var CupRef := %CupRef as Cup
# -> Customer
@onready var CustomerPanelRef := %CustomerPanelRef as CustomerPanel
# -> Tools
@onready var PanelTools := %PanelTools as PanelContainer
@onready var HBoxTools := %HBoxTools as HBoxContainer
@onready var ToolTrashRef := %ToolTrashRef as ToolTrash

# Bottom layer
@onready var PanelBottomLayer := %PanelBottomLayer as PanelContainer
# -> Items
@onready var ItemsTableRef := %ItemsTableRef as ItemsTable

# Customer intro panel
@onready var CustomerIntroRef := %CustomerIntroRef as CustomerIntro
#endregion

#region Virtual Methods
func _ready() -> void:
	# Connections
	Global.cup_dropped_on_customer.connect(_on_Global_cup_dropped_on_customer)
	Global.timer.timeout.connect(_process_end_of_round)
	Global.next_customer_requested.connect(set_next_customer)
	CustomerIntroRef.accepted.connect(_on_CustomerIntroRef_accepted)
	
	# Start game loop
	Global.reset_charon_round()
	set_next_customer()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_input := event as InputEventKey
		
		if key_input.pressed:
			match key_input.keycode:
				KEY_Q: set_next_customer()
				KEY_W: Global.charon_requested.emit()
				KEY_E: Global.adjust_gold(10)
				KEY_R: Global.adjust_gold(-10)
#endregion

#region Public Methods
func set_next_customer() -> void:
	# Reset timer, cup and items
	Global.timer.stop()
	ItemsTableRef.randomize_all_items_positions()
	CupRef.reset()
	
	# Generate new customer
	Global.current_customer = Customer.create_random_customer()
	CustomerIntroRef.show_customer_intro(Global.current_customer)
	
	# Generate new order
	Global.current_order = Order.create_random_order(
		Global.EXTRAS_COUNT_BOUNDS.x, Global.EXTRAS_COUNT_BOUNDS.y
		)
	OrdersMenuRef.update_menu_with_order(Global.current_order)
#endregion

#region Private Methods
func _process_end_of_round() -> void:
	Global.current_round += 1
	Global.gold_to_receive = 0
	
	if Global.current_round % Global.charon_round == 0:
		Global.charon_requested.emit()
	
	else:
		# Game over on time out
		if Global.gold < 0:
			Global.change_main_scene(Global.MainSceneType.END_DEFEAT)
		
		else:
			set_next_customer()
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_Global_cup_dropped_on_customer(customer_is_pleased: bool) -> void:
	if customer_is_pleased:
		Global.gold_to_receive += randi() % 4
		Global.adjust_gold(Global.gold_to_receive)
		
		_process_end_of_round()
		
	else:
		Global.adjust_gold(-(int(Global.gold_to_receive / 4.0) + 2))
		
		# Game over on failed order delivery
		if Global.gold < 0:
			Global.change_main_scene(Global.MainSceneType.END_DEFEAT)


func _on_CustomerIntroRef_accepted(state: bool) -> void:
	# Reset the game loop if the customer is accepted
	if state:
		Global.current_time_interval = randf_range(Global.TIMER_BOUNDS.x, Global.TIMER_BOUNDS.y)
		Global.timer.start(Global.current_time_interval)
		
		CustomerPanelRef.update_customer_panel(Global.current_customer)
	
	# Cycle the next (random) customer
	else:
		set_next_customer()
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
