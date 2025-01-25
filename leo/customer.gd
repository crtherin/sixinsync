extends Node2D

var json_data

var debug = false

func _ready():
	var file_path = "res://Assets/Text/dialogues.txt"  # Path to the JSON file
	json_data = load_json(file_path)
	if json_data && debug:
		for entry in json_data:
			print("Name:", entry.get("name", "Unknown"))
			print("Descr:", entry.get("description", "?"))
			

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
