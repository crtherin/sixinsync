class_name Splash extends Control

@export var particles: GPUParticles2D
signal playSound()

func play() -> void:
	particles.restart()
	playSound.emit()
	
