#@tool
class_name ToolBar
extends MarginContainer

#region Signals
#endregion

#region Enums
#endregion

#region Constants
const LABEL_TIMER_WARNING_THRESHOLD: float = 25.0

const TWEEN_LABEL_TIME_SCALE_VALUE: float = 1.1
const TWEEN_LABEL_TIME_COLOR: Color = Color.ORANGE_RED
const TWEEN_LABEL_TIME_SPEED: float = 0.25
const TWEEN_LABEL_TIME_DELAY: float = 0.15

const TWEEN_LABEL_GOLD_SCALE_VALUE: float = 1.25
const TWEEN_LABEL_GOLD_COLOR_NOK: Color = Color.ORANGE_RED
const TWEEN_LABEL_GOLD_COLOR_OK: Color = Color.LAWN_GREEN
const TWEEN_LABEL_GOLD_SPEED: float = 0.25
#endregion

#region Export Variables
#endregion

#region Public Variables
#endregion

#region Private Variables
var _tween: Tween
#endregion

#region OnReady Variables
@onready var HFlowBackground := %HFlowBackground as HFlowContainer
@onready var ButtonMenu := %ButtonMenu as GameButton

# Timer
@onready var HBoxTimer := %HBoxTimer as Timer
@onready var TextureTimer := %TextureTimer as TextureRect
@onready var LabelTimer := %LabelTimer as Label

# Gold
@onready var HBoxGold := %HBoxGold as Timer
@onready var TextureGold := %TextureGold as TextureRect
@onready var LabelGold := %LabelGold as Label

# Round
@onready var HBoxRound := %HBoxRound as Timer
@onready var TextureRound := %TextureRound as TextureRect
@onready var LabelRound := %LabelRound as Label
#endregion

#region Virtual Methods
func _ready() -> void:
	# Defaults
	LabelTimer.pivot_offset = LabelTimer.size / 2.0
	LabelGold.pivot_offset = LabelGold.size / 2.0
	
	# Connections
	Global.gold_changed.connect(_on_Global_gold_changed)
	
	for button: GameButton in [ButtonMenu]:
		button.pressed.connect(_on_button_pressed.bind(button))



func _physics_process(_delta: float) -> void:
	LabelGold.text = "Obol: %d" % Global.gold
	LabelRound.text = "Round: %d" % (Global.current_round + 1)
	
	if Global.timer.is_stopped():
		return
	
	var percent_left: float = (Global.timer.time_left / Global.current_time_interval) * 100.0
	
	LabelTimer.text = "%02d:%02d" % [
		int(Global.timer.time_left / 60.0),
		int(Global.timer.time_left) % 60,
		]
	
	if percent_left <= LABEL_TIMER_WARNING_THRESHOLD:
		if _tween == null:
			_tween = create_tween()
			_tween.finished.connect(func() -> void: _tween = null)
			
			var scale_value: Vector2 = Vector2.ONE * TWEEN_LABEL_TIME_SCALE_VALUE
			
			_tween.tween_property(
				LabelTimer, ^"scale", scale_value, TWEEN_LABEL_TIME_SPEED
				).set_delay(TWEEN_LABEL_TIME_DELAY)
			
			_tween.parallel().tween_property(
				LabelTimer, ^"modulate", TWEEN_LABEL_TIME_COLOR, TWEEN_LABEL_TIME_SPEED
				)
			
			_tween.chain().tween_property(
				LabelTimer, ^"scale", Vector2.ONE, TWEEN_LABEL_TIME_SPEED
				)
			
			_tween.parallel().tween_property(
				LabelTimer, ^"modulate", Color.WHITE, TWEEN_LABEL_TIME_SPEED
				)
#endregion

#region Public Methods
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
func _on_Global_gold_changed(value: int) -> void:
	var tween: Tween = create_tween()
	var scale_value: Vector2 = Vector2.ONE * TWEEN_LABEL_GOLD_SCALE_VALUE
	var color: Color = TWEEN_LABEL_GOLD_COLOR_NOK if value < 0 else TWEEN_LABEL_GOLD_COLOR_OK
	
	tween.tween_property(
		LabelGold, ^"scale", scale_value, TWEEN_LABEL_GOLD_SPEED
		)
	
	tween.parallel().tween_property(
		LabelGold, ^"modulate", color, TWEEN_LABEL_GOLD_SPEED
		)
	
	tween.tween_property(
		LabelGold, ^"scale", Vector2.ONE, TWEEN_LABEL_GOLD_SPEED
		)
	
	tween.parallel().tween_property(
		LabelGold, ^"modulate", Color.WHITE, TWEEN_LABEL_GOLD_SPEED
		)


func _on_button_pressed(button: GameButton) -> void:
	match button:
		ButtonMenu:
			Global.pause_requested.emit()
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
