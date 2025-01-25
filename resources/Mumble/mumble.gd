class_name Mumbler extends Node

var _alpha_path: String
var player: AudioStreamPlayer
@export var skip: bool = false
enum _alpha {A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z}
var _streams: Array[Resource]
var _currnet_index: int
var _current_text: String
var _regex : RegEx

func _ready() -> void:
	_regex = RegEx.new()
	_regex.compile('([ ./!,()])')

static func getInstance(text: String, path: String, streams: Array[Resource]) -> Mumbler:
	var mumbler = Mumbler.new()
	mumbler._streams = streams
	mumbler._current_text = text.to_upper()
	mumbler.player = AudioStreamPlayer.new()
	mumbler.player.finished.connect(mumbler._on_audio_stream_player_finished)
	mumbler.add_child(mumbler.player)
	return mumbler		

func stringToMorsePop() -> void:
	_currnet_index = 0
	_charToSound(_current_text[_currnet_index])
		
func _charToSound(char: String) -> void:
	player.stream = _streams[_alpha.get(char)]
	player.play()

func _on_audio_stream_player_finished() -> void:
	_currnet_index += 1
	if(_current_text.length() > _currnet_index && !skip):
		if(_regex.search(_current_text[_currnet_index])):
			_on_audio_stream_player_finished()
		_charToSound(_current_text[_currnet_index])
	elif(_current_text.length() <= _currnet_index):
		#todo: add signal to tell manager to eliminate node from list
		queue_free()
