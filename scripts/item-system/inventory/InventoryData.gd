extends Resource
class_name InventoryData

@export var slots: Array[SlotData] = []
@export var active_slot_index: int = 0

func save_inventory():
	ResourceSaver.save(self, "user://inventory_save.tres")

static func load_or_create() -> InventoryData:
	if ResourceLoader.exists("user://inventory_save.tres"):
		return ResourceLoader.load("user://inventory_save.tres")
	
	var new_inv = InventoryData.new()
	for i in range(63): # 54 (inventory) + 9 (hotbar)
		new_inv.slots.append(SlotData.new())
	return new_inv
