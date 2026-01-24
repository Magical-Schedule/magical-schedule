extends Control

func update_ui():
	var text := ""

	for session in Session_Log.sessions:
		text += "[b]Session:[/b] " + session["timestamp"] + "\n"
		text += "Total earned: " + str(session["total_earned"]) + "$\n"
		text += "Final money: " + str(session["final_money"]) + "$\n"
		text += "Items sold:\n"

		for item_name in session["sold_items"].keys():
			var qty = session["sold_items"][item_name]
			var earned = session["earned_money"][item_name]
			text += " - " + item_name + ": " + str(qty) + " pcs, " + str(earned) + "$\n"

		text += "\n"

	var richtext := $Panel/VBoxContainer/ScrollContainer/SessionList
	richtext.bbcode_enabled = true
	richtext.text = text


func _ready():
	var richtext := $Panel/VBoxContainer/ScrollContainer/SessionList
	var scroll := $Panel/VBoxContainer/ScrollContainer
	richtext.bbcode_enabled = true
	scroll.grab_focus()
