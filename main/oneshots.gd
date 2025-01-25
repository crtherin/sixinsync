extends AudioStreamPlayer

@export var sounds_folder : String = "res://Assets/Sounds/Ambiance/Oneshots/"
@export_range(0.1, 100.0) var min_delay : float = 1.0
@export_range(0.1, 100.0) var max_delay : float = 5.0

var sound_files : Array = []

func _ready():
	var dir = DirAccess.open(sounds_folder)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".wav") or file_name.ends_with(".ogg") or file_name.ends_with(".mp3"):
				sound_files.append(sounds_folder + file_name)
			file_name = dir.get_next()
	
	await get_tree().create_timer(randf_range(min_delay, max_delay)).timeout
	play_random_sound()

func play_random_sound():
	if sound_files.is_empty():
		return
	
	stream = load(sound_files.pick_random())
	play()
	
	await finished
	await get_tree().create_timer(randf_range(min_delay, max_delay)).timeout
	play_random_sound()
