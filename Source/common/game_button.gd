#@tool
class_name GameButton
extends Button

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const SOUND_HOVER: AudioStreamWAV = preload("res://Assets/Sounds/Menu/btn_hover.wav")
const SOUND_CLICK: AudioStreamWAV = preload("res://Assets/Sounds/Menu/btn_success.wav")
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
var _hover_audio_player: AudioStreamPlayer
var _click_audio_player: AudioStreamPlayer
#endregion

#region OnReady Variables
#endregion

#region Virtual Methods
func _ready():
	# Audio players setup
	_hover_audio_player = AudioStreamPlayer.new()
	_click_audio_player = AudioStreamPlayer.new()
	
	add_child(_hover_audio_player, false, Node.INTERNAL_MODE_BACK)
	add_child(_click_audio_player, false, Node.INTERNAL_MODE_BACK)
	
	_hover_audio_player.stream = SOUND_HOVER
	_click_audio_player.stream = SOUND_CLICK
	
	# Connections
	mouse_entered.connect(_hover_audio_player.play)
	pressed.connect(_click_audio_player.play)
#endregion

#region Public Methods
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
