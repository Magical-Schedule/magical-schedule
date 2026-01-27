extends Node

var sold_items := {}
var earned_money := {}
var total_earned := 0

func _ready():
	sold_items = {}
	earned_money = {}
	total_earned = 0

func add_sale(item_name: String, quantity: int, price_per_item: int):
	print("ADD SALE CALLED:", item_name, quantity, price_per_item)

	if sold_items.has(item_name):
		sold_items[item_name] += quantity
	else:
		sold_items[item_name] = quantity

	var earned = quantity * price_per_item
	if earned_money.has(item_name):
		earned_money[item_name] += earned
	else:
		earned_money[item_name] = earned

	total_earned += earned
	save_history()

func save_history():
	var file = FileAccess.open("user://sell_history.save", FileAccess.WRITE)
	if file:
		file.store_var({
			"sold_items": sold_items,
			"earned_money": earned_money,
			"total_earned": total_earned
		})

func load_history():
	if FileAccess.file_exists("user://sell_history.save"):
		var file = FileAccess.open("user://sell_history.save", FileAccess.READ)
		var data = file.get_var()
		sold_items = data.get("sold_items", {})
		earned_money = data.get("earned_money", {})
		total_earned = data.get("total_earned", 0)

func end_session(final_money: float):
	print("END SESSION CALLED, final_money = ", final_money)
	var entry = {
		"timestamp": Time.get_datetime_string_from_system(),
		"sold_items": sold_items.duplicate(true),
		"earned_money": earned_money.duplicate(true),
		"total_earned": total_earned,
		"final_money": final_money
	}
	
	Session_Log.add_session(entry)

	sold_items.clear()
	earned_money.clear()
	total_earned = 0

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		var playground = get_tree().root.find_child("Playground", true, false)
		if playground: 
			var final_money = playground.money
			end_session(final_money)
	
