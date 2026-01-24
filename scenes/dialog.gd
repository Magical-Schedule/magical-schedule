extends Control

signal dialogue_finished
signal selling_started
@export_file("*.json") var d_file

var dialogue = []
var current_dialouge_id = 0
var d_active = false
var button_pressed = false

func _ready():
	$dialog.visible = false
	$NO.visible = false
	$Yes.visible = false
	$selling_interest.visible = false
	
func start():
	if d_active:
		return
	d_active = true
	$dialog.visible = true
	dialogue = load_dialouge()
	current_dialouge_id = -1
	next_script()
	
func load_dialouge():
	var file = FileAccess.open("res://assets/NPC_dialog/ricardo_dialog1.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content
	
func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()
	
func next_script():
	current_dialouge_id += 1
	if current_dialouge_id >= len(dialogue):
		d_active = false
		$dialog.visible = false
		var iu =  get_tree().root.find_child("InventoryUi", true, false)
		iu.toggle_sell()
		iu.set_visible_iu()
		return
		
	$dialog/Name.text = dialogue[current_dialouge_id]['name']
	$dialog/text.text = dialogue[current_dialouge_id]['text']
		
		


func _on_yes_button_pressed() -> void:
	$Selling_interest.visable = false
	print("deluje")
	emit_signal("selling_started")
	
	

func _on_no_button_pressed() -> void:
	$Selling_interest.visible = false
	emit_signal("sell_menue_closed")
	
	var playground = get_tree().root.find_child("Playground", true, false)
	if playground:
		var final_money = playground.get_money()
		Sell_History.end_session(final_money)
		
	var history_ui = get_tree().root.find_child("SellHistoryUI", true, false)
	if history_ui:
		history_ui.update_ui()
		
	
