extends Node2D

@onready var pauseMenu = get_node("CanvasLayer/PauseMenu")
<<<<<<< HEAD
@onready var moneyLabel = $CanvasLayer/Label
@onready var buyMenu = $CanvasLayer/BuyInventory
var money = 100
func _ready() -> void:
	moneyLabel.text = str(money) + "$"
=======

func _ready() -> void:
>>>>>>> player-idle-breathing
	pass


func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
		if event.is_action_pressed("pause"):
			print("PAUSING")
			pauseMenu.open_menu()
<<<<<<< HEAD
		if event.is_action_pressed("open_buy_menu"):
			buyMenu.visible = !buyMenu.visible
			if buyMenu.visible:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func get_money():
	return money
	
func sub_money(price:int):
	money-=price
	moneyLabel.text = str(money) + "$"
=======
>>>>>>> player-idle-breathing
