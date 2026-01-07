extends Resource
class_name InventoryData

const WIDTH = 8
const HOTBAR_HEIGHT = 1
const HOTBAR_SIZE = WIDTH * HOTBAR_HEIGHT
const BACKPACK_HEIGHT = 3
const BACKPACK_SIZE = WIDTH * BACKPACK_HEIGHT

@export var backpack_slots: Array[SlotData] = []
@export var hotbar_slots: Array[SlotData] = []
@export var active_slot_index: int = 0

@export_group("Visual Settings")
@export var slot_size: Vector2 = Vector2(100, 100)
@export var slot_background: Texture2D
@export var inactive_transparency: float = 0.6
@export var active_transparency: float = 1.0


func save_inventory():
	ResourceSaver.save(self, "user://inventory_save.tres")

static func load_or_create() -> InventoryData:
	# if ResourceLoader.exists("user://inventory_save.tres"):
	#	return ResourceLoader.load("user://inventory_save.tres")
	
	var new_inv = InventoryData.new()
	
	# Populate the separate arrays using your constants 
	for i in BACKPACK_SIZE:
		new_inv.backpack_slots.append(SlotData.new())
	
	for i in HOTBAR_SIZE:
		new_inv.hotbar_slots.append(SlotData.new())
		
	return new_inv
