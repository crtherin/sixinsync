#@tool
class_name ItemsTable
extends PanelContainer

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
@onready var ItemsContainer := %ItemsContainer as Control
#endregion

#region Virtual Methods
#endregion

#region Public Methods
func randomize_all_items_positions() -> void:
	get_all_items().map(func(item: Item) -> void: item.set_random_position.call_deferred())


func get_all_items() -> Array[Item]:
	return Array(ItemsContainer.get_children(), TYPE_OBJECT, &"TextureRect", Item)
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
