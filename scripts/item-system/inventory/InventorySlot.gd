extends PanelContainer

@onready var icon : TextureRect = $IconTexture
@onready var background : TextureRect = $SlotBackground
@onready var quantity_label: Label = $Label
@onready var selection_frame: Control = $SelectionFrame

var slot_data: SlotData


func set_slot_data(data: SlotData):
	slot_data = data
	if not slot_data.inventory_updated.is_connected(_update_ui):
		slot_data.inventory_updated.connect(_update_ui)
	_update_ui()

func _update_ui():
	if slot_data.item_data:
		icon.texture = slot_data.item_data.icon
		icon.visible = true
		
		# Pull quantity from the component instead of the slot
		var qty = slot_data.item_data.quantity_data.current_stack
		quantity_label.text = str(qty) if qty > 1 else ""
	else:
		icon.visible = false
		quantity_label.text = ""
		
	self.modulate.a = 0.5

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_quick_move()

func _quick_move():
	if !slot_data.item_data: return 
	
	var ui = get_tree().root.find_child("InventoryUI", true, false) 
	var inv_data = ui.inventory_data
	
	# Determine if this slot is currently in the backpack or hotbar
	var is_in_backpack = inv_data.backpack_slots.has(slot_data)
	
	# If in backpack, try to move to hotbar; if in hotbar, move to backpack
	var target_array = inv_data.hotbar_slots if is_in_backpack else inv_data.backpack_slots
	
	for target_slot in target_array:
		# 1. Try to stack first if item is stackable 
		if target_slot.item_data and target_slot.item_data.resource_path == slot_data.item_data.resource_path:
			# Transfer quantities/uses logic here... [cite: 2, 9]
			pass
		
		# 2. Or find an empty slot
		if target_slot.item_data == null:
			target_slot.item_data = slot_data.item_data
			slot_data.item_data = null
			return


func apply_visuals(bg_tex: Texture2D, alpha: float, slot_size: Vector2 = Vector2.ZERO):
	if slot_size != Vector2.ZERO:
		custom_minimum_size = slot_size
		# Ensure the icon matches the new size
		icon.custom_minimum_size = slot_size
	
	if bg_tex: background.texture = bg_tex
	
	# self_modulate affects the node's transparency 
	# without affecting its children (like the icon)
	background.self_modulate.a = alpha 

func set_highlight(is_active: bool, active_alpha: float, inactive_alpha: float):
	if selection_frame:
		selection_frame.visible = is_active
	
	# Adjust transparency based on active state
	var alpha = active_alpha if is_active else inactive_alpha
	apply_visuals(null, alpha) # null because texture is already set
