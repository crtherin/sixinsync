extends Node

@export var path: String
@export var speed: float
var mumblers: Array[Mumbler]
var _streams: Array[Resource]

func _ready():
	var dir =DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_names = dir.get_files()
		for file in file_names:
			if(file.ends_with('.wav')):
				_streams.append(load(path + file))

func mumble(text:String):
	var mumbler = Mumbler.getInstance(text, path, _streams, speed)
	self.add_child(mumbler)
	mumbler.stringToMorsePop()
	mumblers.append(mumbler)
	
func skip():
	for mumbler in mumblers:
		mumbler.skip = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_input := event as InputEventKey
		
		if key_input.pressed:
			match key_input.keycode:
				KEY_0: mumble('Stalin e cel mai tare') #ForTestPurposes
				KEY_SPACE: skip()
				
				
