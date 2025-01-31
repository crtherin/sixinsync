class_name Mumbler extends Node

@export var skip: bool = false
signal onFree(object)
#var _alpha_path: String
var player: AudioStreamPlayer
enum _alpha {A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z}
var _streams: Array[Resource]
var _currnet_index: int
var _current_text: String
var _regex : RegEx

func _ready() -> void:
	_regex = RegEx.new()
	_regex.compile('([A-Z])')

static func getInstance(text: String, _path: String, streams: Array[Resource], pich: float) -> Mumbler:
	var mumbler = Mumbler.new()
	mumbler._streams = streams
	mumbler._current_text = text.to_upper()
	mumbler.player = AudioStreamPlayer.new()
	mumbler.player.bus = &"Speech"
	mumbler.player.pitch_scale = pich
	mumbler.player.finished.connect(mumbler._on_audio_stream_player_finished)
	mumbler.add_child(mumbler.player)
	return mumbler		

func stringToMorsePop() -> void:
	_currnet_index = 0
	#_charToSound(_current_text[_currnet_index])
	_on_audio_stream_player_finished()
		
func _charToSound(character: String) -> void:
	player.stream = _streams[_alpha.get(character)]
	player.play()

func _on_audio_stream_player_finished() -> void:
	if(_current_text.length() > _currnet_index && !skip):
		if(_regex.search(_current_text[_currnet_index])):
			_charToSound(_current_text[_currnet_index])
			_currnet_index += 1
		else:
			_currnet_index += 1
			_on_audio_stream_player_finished()
	elif(_current_text.length() <= _currnet_index):
		onFree.emit(self)
		queue_free()
