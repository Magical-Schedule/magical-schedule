## SlotData
extends Resource
class_name SlotData

signal inventory_updated

@export var item_data: Item: # Points to your new Item.gd
	set(value):
		item_data = value
		inventory_updated.emit()
