#@tool
class_name StartIntro
extends MainScene

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const TWEEN_BACKGROUND_STYLE_TEXTURE_SPEED: float = 5.0
const TWEEN_LOGO_MODULATE_SPEED: float = 2.5
const TWEEN_LOGO_MODULATE_DELAY: float = 0.75
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
var _tween: Tween = create_tween()
#endregion

#region OnReady Variables
# Background
@onready var PanelBackground := %PanelBackground as PanelContainer
@onready var PanelBackgroundStyle := PanelBackground.get_theme_stylebox(&"panel") as StyleBoxTexture
@onready var PanelBackgroundStyleTexture := PanelBackgroundStyle.texture as GradientTexture2D
@onready var PanelBackgroundStyleGradient := PanelBackgroundStyleTexture.gradient as Gradient

@onready var AspectBackground := %AspectBackground as AspectRatioContainer
@onready var TextureLogoGodot := %TextureLogoGodot as TextureRect
@onready var TextureLogoTeam := %TextureLogoTeam as TextureRect
#endregion

#region Virtual Methods
func _ready() -> void:
	TextureLogoGodot.modulate.a = 0.0
	TextureLogoTeam.modulate.a = 0.0
	
	_tween.finished.connect(_on_tween_finished)
	
	# Animate the background style texture
	_tween.tween_property(
		PanelBackgroundStyleTexture, ^"fill_to:x", 1.0, TWEEN_BACKGROUND_STYLE_TEXTURE_SPEED
		)
	
	# Animate the Godot logo
	var tweener_logo_godot_modulate_on: PropertyTweener = _tween.parallel().tween_property(
		TextureLogoGodot, ^"modulate:a", 1.0, TWEEN_LOGO_MODULATE_SPEED
	)
	
	tweener_logo_godot_modulate_on.set_delay(TWEEN_LOGO_MODULATE_DELAY)
	tweener_logo_godot_modulate_on.set_ease(Tween.EASE_IN)
	tweener_logo_godot_modulate_on.set_trans(Tween.TRANS_CUBIC)
	
	var tweener_logo_godot_modulate_off: PropertyTweener = _tween.chain().tween_property(
		TextureLogoGodot, ^"modulate:a", 0.0, TWEEN_LOGO_MODULATE_SPEED
	)
	
	tweener_logo_godot_modulate_off.set_delay(TWEEN_LOGO_MODULATE_DELAY / 2.0)
	
	# Animate the team logo
	var tweener_logo_team_modulate_on: PropertyTweener = _tween.tween_property(
		TextureLogoTeam, ^"modulate:a", 1.0, TWEEN_LOGO_MODULATE_SPEED
	)
	
	tweener_logo_team_modulate_on.set_delay(TWEEN_LOGO_MODULATE_DELAY / 2.0)
	tweener_logo_team_modulate_on.set_ease(Tween.EASE_IN)
	tweener_logo_team_modulate_on.set_trans(Tween.TRANS_CUBIC)
	
	var tweener_logo_team_modulate_off: PropertyTweener = _tween.chain().tween_property(
		TextureLogoTeam, ^"modulate:a", 0.0, TWEEN_LOGO_MODULATE_SPEED
	)
	
	tweener_logo_team_modulate_off.set_delay(TWEEN_LOGO_MODULATE_DELAY)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event := event as InputEventKey
		
		if key_event.pressed:
			match key_event.keycode:
				KEY_ESCAPE:
					_tween.stop()
					_tween.finished.emit()
#endregion

#region Public Methods
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_tween_finished() -> void:
	Global.change_main_scene(Global.MainSceneType.START_MENU)
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
