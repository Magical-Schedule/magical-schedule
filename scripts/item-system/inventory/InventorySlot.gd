extends PanelContainer

@onready var background: TextureRect = $TextureRect2
@onready var icon: TextureRect = get_node("IconWrapper/TextureRect")
@onready var quantity_label: Label = $Label
@onready var selection_frame: Control = $SelectionFrame1

var slot_data: SlotData

## Updating Slot UI
func _update_ui():
	if slot_data.item_data:
		icon.texture = slot_data.item_data.icon
		icon.visible = true
		var qty = slot_data.item_data.quantity_data.current_stack
		quantity_label.text = str(qty) if qty > 1 else ""
	else:
		icon.visible = false
		quantity_label.text = ""

## Setting Slot Data (called in InventoryUI)
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

## Quick Move Helper Method
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

## GUI Input Method
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_quick_move()

## Applies slot visuals
func apply_visuals(bg_tex: Texture2D, alpha: float, slot_size: Vector2 = Vector2.ZERO):
	if slot_size != Vector2.ZERO:
		custom_minimum_size = slot_size
	
	if bg_tex: background.texture = bg_tex
	
	# self_modulate affects the node's transparency 
	# without affecting its children (like the icon)
	self.self_modulate.a = alpha

## Handles slot transparency
func set_highlight(is_focused: bool, active_alpha: float, inactive_alpha: float):
	selection_frame.visible = is_focused
	
	if is_focused:
		self.self_modulate.a = active_alpha
	else:
		self.self_modulate.a = inactive_alpha
		
	# If the icon should also dim when not focused:
	icon.modulate.a = active_alpha if is_focused else inactive_alpha
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

"""  
func set_highlight(is_active: bool):
	if selection_frame:
		selection_frame.visible = is_active
"""
