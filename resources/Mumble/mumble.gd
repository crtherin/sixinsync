extends Node

@export var alpha_path: String = 'res://Assets/Sounds/MorseCode/'
@onready var player: AudioStreamPlayer = $AudioStreamPlayer
@export var skip: bool = false
enum alpha {A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z}
var streams: Array[Resource]
var _currnet_index: int
var _current_text: String

func _ready():
	_load_resources(alpha_path)#Loads all letters

func _load_resources(path):
	var dir =DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_names = dir.get_files()
		for file in file_names:
			if(file.ends_with('.wav')):
				streams.append(load(alpha_path + file))

			

func stringToMorsePop(text: String) -> void:
	_currnet_index = 0
	_current_text = text.to_upper()
	_charToSound(text[_currnet_index])
		
func _charToSound(char: String) -> void:
	player.stream = streams[alpha.get(char)]
	player.play()

#ForTestPurposes
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_input := event as InputEventKey
		
		if key_input.pressed:
			match key_input.keycode:
				KEY_Q: stringToMorsePop('Stalin e cel mai tare')

func _on_audio_stream_player_finished() -> void:
	_currnet_index += 1
	if(_current_text.length() >= _currnet_index && !skip):
		_charToSound(_current_text[_currnet_index])
