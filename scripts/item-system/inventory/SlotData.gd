extends Resource
class_name SlotData

signal inventory_updated

@export var item_data: Item:
	set(value):
		item_data = value
		if item_data and item_data.quantity_data:
			item_data.quantity_data.initialize() # Set current_uses to max_uses 
		inventory_updated.emit()

@export var quantity: int = 0:
	set(value):
		quantity = value
		if quantity <= 0:
			item_data = null
		inventory_updated.emit()
