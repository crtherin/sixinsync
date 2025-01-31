#@tool
class_name PauseLayer
extends CanvasLayer

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const TEXT_EXIT_MENU: String = "Are you sure you want to exit to the main menu?"
const TEXT_EXIT_GAME: String = "Are you sure you want to exit the game?"

const TWEEN_EXIT_MODULATE_SPEED: float = 0.25
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
var _exit_mode_is_menu: bool
#endregion

#region OnReady Variables
# Background
@onready var ColorBackgroundShader := %ColorBackgroundShader as ColorRect
@onready var MarginBackground := %MarginBackground as MarginContainer
@onready var VBoxBackground := %VBoxBackground as VBoxContainer
@onready var TextureLogo := %TextureLogo as TextureRect

# Buttons
@onready var VBoxButtons := %VBoxButtons as VBoxContainer
@onready var ButtonResume := %ButtonResume as GameButton
@onready var ButtonExitMenu := %ButtonExitMenu as GameButton
@onready var ButtonExitGame := %ButtonExitGame as GameButton

# Exit Confirmation
@onready var ColorExit := %ColorExit as ColorRect
@onready var LabelExit := %LabelExit as Label
@onready var HBoxExitButtons := %HBoxExitButtons as HBoxContainer
@onready var ButtonExitNo := %ButtonExitNo as GameButton
@onready var ButtonExitYes := %ButtonExitYes as GameButton
#endregion

#region Virtual Methods
func _ready() -> void:
	# Defaults
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	ColorExit.visible = false
	ColorExit.modulate.a = 0.0
	
	_set_paused(false)
	
	# Connections
	Global.pause_requested.connect(_set_paused.bind(true))
	
	var all_buttons: Array[GameButton] = [
		ButtonResume, ButtonExitMenu, ButtonExitGame, ButtonExitNo, ButtonExitYes,
		]
	
	all_buttons.map(func(button: GameButton) -> void:
		button.pressed.connect(_on_button_pressed.bind(button))
		)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_input := event as InputEventKey
		
		if key_input.pressed:
			match key_input.keycode:
				KEY_ESCAPE: _set_paused(not Global.is_paused)
#endregion

#region Public Methods
#endregion

#region Private Methods
func _set_paused(mode: bool) -> void:
	if ColorExit.visible:
		_show_exit_confirmation(false)
		return
	
	Global.is_paused = mode
	get_tree().paused = mode
	visible = mode
	
	Input.set_custom_mouse_cursor(
		null if mode else (Global.CURSOR_CLOSED if Global.is_grabbing_item else Global.CURSOR_OPEN)
		)


func _show_exit_confirmation(state: bool) -> void:
	var tween: Tween = create_tween()
	
	if state:
		ColorExit.visible = true
		ColorExit.modulate.a = 0.0
		
		tween.tween_property(ColorExit, ^"modulate:a", 1.0, TWEEN_EXIT_MODULATE_SPEED)
	
	else:
		tween.tween_property(ColorExit, ^"modulate:a", 0.0, TWEEN_EXIT_MODULATE_SPEED)
		tween.tween_callback(ColorExit.hide)
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_button_pressed(button: GameButton) -> void:
	match button:
		ButtonResume:
			_set_paused(false)
			
		ButtonExitMenu:
			_exit_mode_is_menu = true
			LabelExit.text = TEXT_EXIT_MENU
			_show_exit_confirmation(true)
			
		ButtonExitGame:
			_exit_mode_is_menu = false
			LabelExit.text = TEXT_EXIT_GAME
			_show_exit_confirmation(true)
			
		ButtonExitNo:
			_show_exit_confirmation(false)
			
		ButtonExitYes:
			if _exit_mode_is_menu:
				Global.change_main_scene(Global.MainSceneType.START_MENU)
			
			else:
				get_tree().quit()
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
