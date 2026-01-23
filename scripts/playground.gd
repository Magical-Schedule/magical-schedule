extends Node2D

@onready var pauseMenu = get_node("CanvasLayer/PauseMenu")
@onready var moneyLabel = $CanvasLayer/Label
@onready var buyMenu = $CanvasLayer/BuyInventory

var money = 100

func _ready() -> void:
	moneyLabel.text = str(money) + "$"

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Sell_History.end_session(get_money())

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	# Odpri/zapri pause menu
	if event.is_action_pressed("pause"):
		pauseMenu.open_menu()

	# Odpri/zapri buy menu
	if event.is_action_pressed("open_buy_menu"):
		buyMenu.visible = !buyMenu.visible
		if buyMenu.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	if event.is_action_pressed("open_session_history"):
		var ui = get_tree().root.find_child("SessionHistoryUI", true, false)
		if ui:
			ui.visible = !ui.visible
			if ui.visible:
				ui.update_ui()

	if event.is_action_pressed("open_sell_history"):
		var ui = get_tree().root.find_child("SellHistoryUI", true, false)
		if ui:
			ui.visible = !ui.visible
			ui.update_ui()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	
func get_money() -> int:
	return money


func sub_money(price: int) -> void:
	money -= price
	moneyLabel.text = str(money) + "$"

func _exit_tree():
	var final_money = get_money()
	Sell_History.end_session(final_money)
