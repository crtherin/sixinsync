#@tool
class_name Customer
extends RefCounted

#region Signals
#endregion

#region Enums
#endregion

#region Constants
#endregion

#region Export Variables
#endregion

#region Public Variables
var id: int

var name: String
var description: String

var opening_texts: Array
var closing_texts: Array

var texture: Texture2D
#endregion

#region Private Variables
#endregion

#region OnReady Variables
#endregion

#region Virtual Methods
func _to_string() -> String:
	return "<Cusotmer[%s][DescLen:%d][OpenCount:%d][CloseCount:%d][TxOk:%s]>" % [
		name, description.length(), opening_texts.size(), closing_texts.size(), texture != null
		]
#endregion

#region Public Methods
#endregion

#region Private Methods
#endregion

#region Static Methods
static func create_specific_customer(customer_id: int) -> Customer:
	var customer: Customer = Customer.new()
	
	_set_customer_data(customer, clampi(customer_id, 2, 13))
	
	return customer


static func create_random_customer() -> Customer:
	var customer: Customer = Customer.new()
	
	_set_customer_data(customer, randi_range(2, 13))
	
	return customer


static func _set_customer_data(customer: Customer, customer_id: int) -> void:
	var data: Dictionary
	
	for data_entry: Dictionary in Global.customers_data:
		if data_entry.get("id", -1.0) == float(customer_id):
			data = data_entry
			break
	
	customer.id = customer_id
	customer.name = data.get("name", "N/A")
	customer.description = data.get("description", "N/A")
	customer.opening_texts = data.get("opening", [])
	customer.closing_texts = data.get("closing", [])
	customer.texture = load(data.get("icon", null))
#endregion

#region Signal Callbacks
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
