extends Node

@export var particles: GPUParticles2D
signal playSound()

func play() -> void:
	particles.restart()
	playSound.emit()
	
