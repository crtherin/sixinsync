#@tool
class_name OrdersMenu
extends PanelContainer

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const ICON_SIZE: float = 100.0
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
#endregion

#region OnReady Variables
@onready var MarginBackground := %MarginBackground as MarginContainer
@onready var VBoxBackground := %VBoxBackground as VBoxContainer
@onready var LabelTitle := %LabelTitle as Label
@onready var ScrollBackground := %ScrollBackground as ScrollContainer
@onready var GridBackground := %GridBackground as GridContainer
#endregion

#region Virtual Methods
#endregion

#region Public Methods
func reset() -> void:
	for child: Node in GridBackground.get_children():
		child.queue_free()
	
	LabelTitle.text = ""


func update_menu_with_order(order: Order) -> void:
	if order == null:
		push_error("The provided order reference is null!")
		return
	
	reset()
	
	LabelTitle.text = order.name
	
	for item_type: ItemData.Type in order.get_every_required_item():
		var item_icon: TextureRect = TextureRect.new()
		
		item_icon.custom_minimum_size = Vector2.ONE * ICON_SIZE
		item_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		item_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		item_icon.texture = ItemData.MAPPED_TEXTURES[item_type]
		
		GridBackground.add_child(item_icon)
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
