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
@onready var VBoxCharArea := %VBoxCharArea as VBoxContainer
@onready var PanelStats := %PanelStats as PanelContainer
@onready var PanelChar := %PanelChar as PanelContainer
@onready var PanelItems := %PanelItems as PanelContainer
@onready var ItemsContainer := %ItemsContainer as Control
#endregion

#region Virtual Methods
func _ready() -> void:
	get_items().map(func(item: Item) -> void: item.dropped.connect(_on_item_dropped.bind(item)))
#endregion

#region Public Methods
func get_items() -> Array[Item]:
	return Array(ItemsContainer.get_children(), TYPE_OBJECT, &"TextureRect", Item)
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_item_dropped(item: Item) -> void:
	print(item)
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
