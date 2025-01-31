#@tool
class_name StartMenu
extends MainScene

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const TWEEN_SHADER_MAX_VALUE: float = 3.0
const TWEEN_SHADER_SPEED: float = 10.0
const TWEEN_LOGO_MODULATE_SPEED: float = 1.0
const TWEEN_EXIT_MODULATE_SPEED: float = 0.25
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
#endregion

#region OnReady Variables
# Background
@onready var PanelBackground := %PanelBackground as PanelContainer
@onready var ColorBackgroundShader := %ColorBackgroundShader as ColorRect
@onready var ColorBackgroundShaderMaterial := ColorBackgroundShader.material as ShaderMaterial
@onready var VBoxBackground := %VBoxBackground as VBoxContainer
@onready var AspectBackground := %AspectBackground as AspectRatioContainer
@onready var HBoxBackground := %HBoxBackground as HBoxContainer

# Logo
@onready var TextureLogo := %TextureLogo as TextureRect
@onready var TextureLogoShadow := %TextureLogoShadow as TextureRect

# Buttons
@onready var MarginButtons := %MarginButtons as MarginContainer
@onready var VBoxButtons := %VBoxButtons as VBoxContainer
@onready var ButtonNewGame := %ButtonNewGame as GameButton
@onready var ButtonCredits := %ButtonCredits as GameButton
@onready var ButtonExit := %ButtonExit as GameButton

# Version
@onready var MarginVersion := %MarginVersion as MarginContainer
@onready var LabelVersion := %LabelVersion as Label

# Exit Confirmation
@onready var ColorExitShader := %ColorExitShader as ColorRect
@onready var LabelExit := %LabelExit as Label
@onready var HBoxExitButtons := %HBoxExitButtons as HBoxContainer
@onready var ButtonExitNo := %ButtonExitNo as GameButton
@onready var ButtonExitYes := %ButtonExitYes as GameButton
#endregion

#region Virtual Methods
func _ready() -> void:
	# Defaults
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	TextureLogo.modulate.a = 0.0
	ColorExitShader.visible = false
	ColorExitShader.modulate.a = 0.0
	
	var all_buttons: Array[GameButton] = [
		ButtonNewGame, ButtonCredits, ButtonExit,
		ButtonExitNo, ButtonExitYes,
		]
	
	all_buttons.map(func(button: GameButton) -> void:
		button.pressed.connect(_on_button_pressed.bind(button))
		)
	
	# Animtations
	var tween: Tween = create_tween()
	
	# Animate the shader
	var func_animate_shader: Callable = func(value: float) -> void:
		ColorBackgroundShaderMaterial.set_shader_parameter(&"fire_aperture", value)
	
	tween.tween_method(func_animate_shader, 0.0, TWEEN_SHADER_MAX_VALUE, TWEEN_SHADER_SPEED)
	
	# Animate the logo
	tween.parallel().tween_property(TextureLogo, ^"modulate:a", 1.0, TWEEN_LOGO_MODULATE_SPEED)
#endregion

#region Public Methods
#endregion

#region Private Methods
func _show_exit_confirmation(state: bool) -> void:
	var tween: Tween = create_tween()
	
	if state:
		ColorExitShader.visible = true
		ColorExitShader.modulate.a = 0.0
		
		tween.tween_property(ColorExitShader, ^"modulate:a", 1.0, TWEEN_EXIT_MODULATE_SPEED)
	
	else:
		tween.tween_property(ColorExitShader, ^"modulate:a", 0.0, TWEEN_EXIT_MODULATE_SPEED)
		tween.tween_callback(ColorExitShader.hide)
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_button_pressed(button: GameButton) -> void:
	match button:
		ButtonNewGame: Global.change_main_scene(Global.MainSceneType.GAME)
		ButtonCredits: Global.change_main_scene(Global.MainSceneType.CREDITS)
		ButtonExit: _show_exit_confirmation(true)
		ButtonExitNo: _show_exit_confirmation(false)
		ButtonExitYes: get_tree().quit()
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
