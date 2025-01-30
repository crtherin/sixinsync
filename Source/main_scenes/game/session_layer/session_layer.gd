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
	CustomerIntroRef.accepted.connect(_on_CustomerIntroRef_accepted)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_input := event as InputEventKey
		
		if key_input.pressed:
			match key_input.keycode:
				KEY_Q: set_next_customer()
#endregion

#region Public Methods
func set_next_customer() -> void:
	# Reset cup and items
	ItemsTableRef.randomize_all_items_positions()
	CupRef.reset()
	
	# Generate new customer
	Global.current_customer = Customer.create_random_customer()
	CustomerIntroRef.show_customer_intro(Global.current_customer)
	
	# Generate new order
	Global.current_order = Order.create_random_order(1, 3)
	OrdersMenuRef.update_menu_with_order(Global.current_order)
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_CustomerIntroRef_accepted(state: bool) -> void:
	if state:
		CustomerPanelRef.update_with_customer(Global.current_customer)
	
	else:
		set_next_customer()
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
