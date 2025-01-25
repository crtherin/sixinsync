extends Control

@onready var icon_container = $IconCotainer

@export var icon_texture: Texture2D  # Default icon texture
@export var icon_size: Vector2 = Vector2(64, 64)  # Size of each icon

# Add icons to the panel
func add_icons(icon_count: int):
	# Clear previous icons
	for child in icon_container.get_children():
		child.queue_free()
	
	# Add new icons
	for i in range(icon_count):
		var icon_button = TextureButton.new()
		icon_button.texture_normal = icon_texture
		icon_button.ignore_texture_size = true
		icon_button.stretch_mode = TextureButton.STRETCH_SCALE
		icon_button.custom_minimum_size = icon_size  # Set the size of the icon
		icon_container.add_child(icon_button)

# Example usage
func _ready():
	add_icons(5)  # Display 5 icons initially
	
