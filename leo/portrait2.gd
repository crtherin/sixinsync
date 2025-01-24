extends TextureButton

@onready var chat_bubble = $"../ChatBubble"	
@onready var customer = $".."

var currentCustomerId = 1
var customerDone = false
var defaultIcon = preload("res://Assets/Portraits/Godot_icon.svg")

func _ready():
	texture_normal = defaultIcon

func getTextForCustomer(id):
	return customer.getCustomer(id)

func _on_pressed():
	if customerDone:
		currentCustomerId += 1
		customerDone = false
		
	var customer = getTextForCustomer(currentCustomerId)
	if customer:
		var texture = load(customer.get("icon"))
		if texture:
			texture_normal = texture
		else:
			texture_normal = defaultIcon
		chat_bubble.show_bubble(customer.get("description"))


func _on_button_pressed():
	customerDone = true
	_on_pressed()
