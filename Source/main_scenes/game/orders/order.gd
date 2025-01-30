#@tool
class_name Order
extends RefCounted

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const DEFAULT_RANDOM_ORDER_NAME: String = "Chaotic Aberration"
#endregion

#region Export Variables
#endregion

#region Public Variables
var name: String: get = _get_name
var tea: ItemData.Type = ItemData.Type.NONE
var milk: ItemData.Type = ItemData.Type.NONE
var boba: ItemData.Type = ItemData.Type.NONE
var extras: Array[ItemData.Type] = []
#endregion

#region Private Variables
#endregion

#region OnReady Variables
#endregion

#region Virtual Methods
func _to_string() -> String:
	return "<Order[%s][Tea:%s][Milk:%s][Boba:%s][Extras:%s]>" % [
		name, tea, milk, boba, (", ".join(extras))
		]
#endregion

#region Public Methods
func get_every_required_item() -> Array[ItemData.Type]:
	return Array([tea] + [milk] + [boba] + extras, TYPE_INT, &"", ItemData.Type)


func check_validity(
	tea_type: ItemData.Type, milk_type: ItemData.Type,
	boba_type: ItemData.Type, extras_types: Array[ItemData.Type]
	) -> bool:
		if tea_type != tea or milk_type != milk or boba_type != boba:
			print_debug(
				"Tea: %s/%s | Milk: %s/%s | Boba: %s/%s" %
				[tea_type, tea, milk_type, milk, boba_type, boba]
				)
			return false
		
		if not extras.is_empty():
			var valid_extras_count: int = 0
			
			for extras_type: ItemData.Type in extras_types:
				valid_extras_count += int(extras_type in extras)
			
			if valid_extras_count != extras.size():
				print_debug("Extras: %s/%s" % [extras_types, extras])
				return false
		
		return true
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
static func create_random_order(min_extras_count: int, max_extras_count: int) -> Order:
	var order: Order = Order.new()
	
	min_extras_count = clampi(min_extras_count, 0, ItemData.ALL_EXTRAS.size())
	max_extras_count = clampi(max_extras_count, 0, ItemData.ALL_EXTRAS.size())
	
	var rand_extras_count: int = randi_range(
		mini(min_extras_count, max_extras_count),
		maxi(min_extras_count, max_extras_count),
		)
	
	order.name = DEFAULT_RANDOM_ORDER_NAME
	order.tea = ItemData.ALL_TEAS[randi_range(0, ItemData.ALL_TEAS.size() - 1)]
	order.milk = ItemData.ALL_MILKS[randi_range(0, ItemData.ALL_MILKS.size() - 1)]
	order.boba = ItemData.ALL_BOBAS[randi_range(0, ItemData.ALL_BOBAS.size() - 1)]
	
	var all_extras_copy := ItemData.ALL_EXTRAS.duplicate() as Array[ItemData.Type]
	
	for __: int in rand_extras_count:
		order.extras.append(all_extras_copy.pop_at(randi_range(1, all_extras_copy.size() - 1)))
	
	return order


static func create_custom_order(
	name_text: String, tea_type: ItemData.Type, milk_type: ItemData.Type,
	boba_type: ItemData.Type, extras_types: Array[ItemData.Type]
	) -> Order:
		name_text = name_text.strip_edges().strip_escapes()
		
		if name_text.is_empty():
			push_error("No name was provided!")
			return null
		
		if tea_type not in ItemData.ALL_TEAS:
			push_error("The provided tea type: %s, is not valid!" % tea_type)
			return null
		
		if milk_type not in ItemData.ALL_MILKS:
			push_error("The provided milk type: %s, is not valid!" % milk_type)
			return null
		
		if boba_type not in ItemData.ALL_BOBAS:
			push_error("The provided boba type: %s, is not valid!" % boba_type)
			return null
		
		for extras_type: ItemData.Type in extras_types:
			if extras_type not in ItemData.ALL_EXTRAS:
				push_error("The provided extras type: %s, is not valid!" % extras_type)
				return null
		
		var order: Order = Order.new()
		
		order.name = name_text
		order.tea = tea_type
		order.milk = milk_type
		order.boba = boba_type
		order.extras = extras_types
		
		return order
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
func _get_name() -> String:
	return name.strip_edges().strip_escapes()
#endregion
