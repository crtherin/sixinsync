extends Node

@export var particles: GPUParticles2D
signal playSound()

func play() -> void:
	particles.restart()
	playSound.emit()
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_input := event as InputEventKey
		
		if key_input.pressed:
			match key_input.keycode: #ForTestPurposes
				KEY_SPACE: play()
