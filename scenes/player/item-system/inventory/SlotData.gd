extends Resource
class_name SlotData

signal inventory_updated

@export var item_data: ItemData
@export var quantity: int = 0:
	set(value):
		quantity = value
		if quantity <= 0:
			item_data = null
		inventory_updated.emit()
