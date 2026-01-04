extends PanelContainer

@onready var color_rect: ColorRect = $PlaceholderIcon
@onready var quantity_label: Label = $Label

var slot_data: SlotData

func set_slot_data(data: SlotData):
	slot_data = data
	if not slot_data.inventory_updated.is_connected(_update_ui):
		slot_data.inventory_updated.connect(_update_ui)
	_update_ui()

func _update_ui():
	if slot_data.item_data:
		color_rect.color = slot_data.item_data.color
		color_rect.visible = true
		quantity_label.text = str(slot_data.quantity) if slot_data.quantity > 1 else ""
		tooltip_text = slot_data.item_data.name
	else:
		color_rect.visible = false
		quantity_label.text = ""
		tooltip_text = ""

func _get_drag_data(_at_position):
	if slot_data.item_data:
		var preview = ColorRect.new()
		preview.color = slot_data.item_data.color
		preview.custom_minimum_size = Vector2(40, 40)
		set_drag_preview(preview)
		return slot_data
	return null

func _can_drop_data(_at_position, data):
	return data is SlotData

# Popravljena vrstica 37 v InventorySlot.gd
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# Najprej preverimo, če je 'data' dejansko tipa SlotData
	if data is SlotData:
		if slot_data.item_data == data.item_data and slot_data.item_data.stackable:
			slot_data.quantity += data.quantity
			data.quantity = 0
		else:
			var temp_item = slot_data.item_data
			var temp_qty = slot_data.quantity
			
			slot_data.item_data = data.item_data
			slot_data.quantity = data.quantity
			
			data.item_data = temp_item
			data.quantity = temp_qty
