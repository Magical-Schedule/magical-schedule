extends PanelContainer

@onready var Icon: TextureRect = get_node("IconWrapper/TextureRect")
@onready var quantity_label: Label = $Label
@onready var selection_frame: Control = $SelectionFrame1

var slot_data: SlotData

func play_move_sound():
	var ui = get_tree().root.find_child("InventorySlot", true, false)
	if ui:
		var sfx = ui.get_node_or_null("Move_item_sfx")
		if sfx:
			sfx.pitch_scale = randf_range(1.1, 1.3)
			sfx.play()
			
func set_slot_data(data: SlotData):
	slot_data = data
	if not slot_data.inventory_updated.is_connected(_update_ui):
		slot_data.inventory_updated.connect(_update_ui)
	_update_ui()

func _update_ui():
	if slot_data.item_data:
		Icon.texture = slot_data.item_data.icon
		Icon.visible = true
		quantity_label.text = str(slot_data.quantity) if slot_data.quantity > 1 else ""
	else:
		Icon.visible = false
		quantity_label.text = ""

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		_quick_move()



func _quick_move():
	if !slot_data.item_data: return
	var iu =  get_tree().root.find_child("InventoryUi", true, false)
	if iu.sell:
		Sell_History.add_sale(slot_data.item_data.name, slot_data.quantity, slot_data.item_data.price)
		var history_ui = get_tree().root.find_child("SellHistoryUI", true, false)
		if history_ui:
			history_ui.update_ui()
			
		sell_item(slot_data.item_data, slot_data.quantity)
		slot_data.item_data = null
		slot_data.quantity = 0
		play_move_sound()
		return
		
	# Išče InventoryUi vozlišče v drevesu
	var ui = get_tree().root.find_child("InventoryUi", true, false)
	if !ui: return
	
	var inv_data = ui.inventory_data
	var idx = inv_data.slots.find(slot_data)
	# Če je v nahrbtniku (0-53), išče v hotbarju (54-62) in obratno
	var target_range = range(54, 63) if idx < 54 else range(0, 54)
	
	for i in target_range:
		var target = inv_data.slots[i]
		if target.item_data == null or (target.item_data == slot_data.item_data and target.item_data.stackable):
			if target.item_data == null: target.item_data = slot_data.item_data
			target.quantity += slot_data.quantity
			slot_data.quantity = 0
			play_move_sound()
			return
			
# --- DODANE FUNKCIJE ZA VIZUALNI FEEDBACK ---
func _ready():
	# Povežemo signala za zaznavanje miške. 
	# self.mouse_entered se sproži, ko miška pride nad slot.
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
func _on_mouse_entered() -> void:
	# Povečamo svetlost za 30% pa še malo povečamo sloth
	scale = Vector2(1.05, 1.05)
	modulate = Color(1.3, 1.3, 1.3)

func _on_mouse_exited() -> void: 
	# Ko miška zapusti območje, vrnemo vse vrednosti v prvotno stanje
	scale = Vector2(1.0, 1.0)
	modulate = Color(1, 1, 1)
  
func set_highlight(is_active: bool):
	if selection_frame:
		selection_frame.visible = is_active

func sell_item(item: ItemData, quantity:int):
	var playground  =  get_tree().root.find_child("Playground", true, false)
	playground.sub_money(-item.price*quantity)
	
