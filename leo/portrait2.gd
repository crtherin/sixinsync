extends TextureButton

@onready var chat_bubble = $"../ChatBubble"	
@onready var customer = $".."

var defaultIcon = preload("res://Assets/Godot_icon.svg")

func _ready():
	texture_normal = defaultIcon


func _on_portrait_pressed():		
	var customer = Global.getCurrentCustomer()
	if customer:
		var texture = load(customer.get("icon"))
		if texture:
			texture_normal = texture
		else:
			texture_normal = defaultIcon
		chat_bubble.show_bubble(customer.get("description"))


func _on_reset_pressed():
	Global.resetCustomer()
	_on_portrait_pressed()
