extends Node2D

@onready var pauseMenu = get_node("CanvasLayer/PauseMenu")
@onready var moneyLabel = $CanvasLayer/MoneyLabel
@onready var buyMenu = $CanvasLayer/BuyInventory


	## ENDING

@onready var endingLabel = $CanvasLayer/EndingLabel
@onready var endingSFX = $CanvasLayer/EndingLabel/EndingSFX


func _play_ending_sound() -> void:
	if endingSFX == null: return
		
	# Setting sound effect stream
	endingSFX.stream = preload("res://assets/sounds/sfx_ending.mp3")
	
	# Pitch setting, then play
	endingSFX.play()

func _trigger_ending() -> void:
	if endingLabel == null: return
	
	endingLabel.visible = true
	
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.1, 0.1, 0.1, 0.8)
	endingLabel.add_theme_stylebox_override("normal", style_box)
	
	endingLabel.text = "The End"
	endingLabel.add_theme_color_override("font_color", Color.GOLD)
	
	endingLabel.scale = Vector2(2, 2)
	
	_play_ending_sound()
	
	_exit_tree()

	## MONEY IMPLEMENTATION

var money: float = 100.0
var money_target: float = 1000.0

func get_money() -> float:
	return money
	
func _check_if_target_money_reached() -> void:
	if money >= money_target: _trigger_ending()

func _init_money_label() -> void:
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.1, 0.2, 0.1, 0.9)
	moneyLabel.add_theme_stylebox_override("normal", style_box)
	moneyLabel.add_theme_color_override("font_color", Color.GREEN)

func _set_money_label_value() -> void:
	moneyLabel.text = "€" + ("%.2f" % money)
	moneyLabel.text += " / " + "€" + ("%.2f" % money_target) + "\n"
	moneyLabel.text += "[" + ("%.2f" % (money/money_target * 100)) + "%]"

func modify_balance(price: float) -> void:
	money += price
	_check_if_target_money_reached()
	_set_money_label_value()


## GAME ENGINE METHODS

func _exit_tree():
	Sell_History.end_session(money)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_exit_tree()

func _process(_delta: float) -> void:
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
	
func _ready() -> void:
	_check_if_target_money_reached()
	_init_money_label()
	_set_money_label_value()
