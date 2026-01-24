extends Control

func _ready():
	update_ui()

func update_ui():
	var text := ""

	text += "Total earned: " + str(Sell_History.total_earned) + "\n\n"

	text += "Earnings by item:\n"
	print("UPDATE UI CALLED")

	for item_name in Sell_History.earned_money.keys():
		var earned = Sell_History.earned_money[item_name]
		var sold = Sell_History.sold_items.get(item_name, 0)
		text += "- " + item_name + ": " + str(sold) + " sold, " + str(earned) + "$ earned\n"

	$VBoxContainer/HistoryText.text = text
