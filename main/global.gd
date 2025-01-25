#@tool
#class_name Global
extends Node

#region Signals
@warning_ignore("unused_signal")
signal item_dropped_in_cup(item: Item)

@warning_ignore("unused_signal")
signal cup_dropped_on_customer

@warning_ignore("unused_signal")
signal cup_dropped_on_trash

@warning_ignore("unused_signal")
signal warning_message_requested(text: String)
#endregion

#region Enums
#endregion

#region Constants
#endregion

#region Export Variables
#endregion

#region Public Variables
var is_paused: bool
var item_is_dragging: bool
var cup_is_dragging: bool

var current_quest: Dictionary = {
	"tea": -1,
	"milk": -1,
	"bubble": -1,
	"extras": [],
}

var customerDone = false
#endregion

#region Private Variables
var customerArray : Array
var currentCustomer
var currentCustomerIndex = 0
#endregion

#region OnReady Variables
#endregion

#region Virtual Methods
#endregion

#region Public Methods
#endregion

#region Private Methods
func _ready():
	var file_path = "res://Assets/Text/dialogues.txt"  # Path to the JSON file
	var json_data = load_json(file_path)
	if json_data:
		customerArray = json_data
		currentCustomer = customerArray[currentCustomerIndex]
		#for entry in json_data:
			#print("Name:", entry.get("name", "Unknown"))
			#print("Descr:", entry.get("description", "?"))
			
# Function to load and parse the JSON file
func load_json(file_path: String) -> Array:
	# Open the file for reading
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()  # Read the file content as text
		file.close()

		 # Create an instance of the JSON parser and parse the string
		var json_parser = JSON.new()
		var json_result = json_parser.parse(json_string)
		if json_result == OK:
			if typeof(json_parser.data) == TYPE_ARRAY:
				return json_parser.data  # Access the parsed data as a Dictionary
			else:
				print("JSON is not an array")
		else:
			print("Error parsing JSON:", json_parser.error_message)
	else:
		print("File does not exist:", file_path)
	return []
	
func resetCustomer():
	setCustomerDone(false)
	newCustomer()
	
func newCustomer():
	currentCustomerIndex += 1
	currentCustomer = customerArray[currentCustomerIndex]
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
#endregion

#region SubClasses
#endregion

#region Setter Methods
func setCustomerDone(done: bool):
	customerDone = done
#endregion

#region Getter Methods
func getCurrentCustomer():
	return currentCustomer

func getCustomer(id):
	var result
	if customerArray:
		for entry in customerArray:
			if entry.get("id") == id:
				result = entry
				
	return result
#endregion
