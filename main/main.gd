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
#endregion

#region Private Variables
#endregion

#region OnReady Variables
@onready var PanelBackground := %PanelBackground as PanelContainer
@onready var MarginBackground := %MarginBackground as MarginContainer
@onready var VBoxBackground := %VBoxBackground as VBoxContainer
@onready var HBoxGameArea := %HBoxGameArea as HBoxContainer
@onready var PanelQuest := %PanelQuest as PanelContainer
@onready var PanelCup := %PanelCup as PanelContainer
@onready var MarginCup := %MarginCup as MarginContainer
@onready var AspectRatioCup := %AspectRatioCup as AspectRatioContainer
@onready var VBoxCustomer := %VBoxCustomer as VBoxContainer
@onready var PanelStats := %PanelStats as PanelContainer
@onready var PanelCustomer := %PanelCustomer as PanelContainer
@onready var PanelItems := %PanelItems as PanelContainer
@onready var ItemsContainer := %ItemsContainer as Control
@onready var PanelTrash := %PanelTrash as PanelContainer
#endregion

#region Virtual Methods
func _ready() -> void:
	Global.cup_dropped_on_customer.connect(_on_cup_dropped_on_customer)
	Global.cup_dropped_on_trash.connect(_on_cup_dropped_on_trash)
#endregion

#region Public Methods
func randomize_item_positions() -> void:
	pass


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
