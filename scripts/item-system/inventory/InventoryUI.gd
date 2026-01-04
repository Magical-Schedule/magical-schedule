extends Control

@export var slot_scene: PackedScene
@onready var inv_grid = $Panel/VBoxContainer/InventoryGrid
@onready var hotbar_grid = $Panel2/VBoxContainer/HotbarGrid

@onready var inv_panel = $Panel
@onready var hotbar_panel = $Panel2


var inventory_data: InventoryData

func _ready():
	print("creating inventory")
	inventory_data = InventoryData.load_or_create()
	inv_panel.visible = false 
	hotbar_panel.visible = true
	populate_grids()
#naredi inventory
func populate_grids():
	for child in inv_grid.get_children(): child.queue_free()
	for child in hotbar_grid.get_children(): child.queue_free()

	for i in range(inventory_data.slots.size()):
		var slot_visual = slot_scene.instantiate()
		if i < 54:
			inv_grid.add_child(slot_visual)
		else:
			hotbar_grid.add_child(slot_visual)
		slot_visual.set_slot_data(inventory_data.slots[i])
#inventory toggle z E
func _input(event):
	if event.is_action_pressed("inventory_toggle"): 
		if inv_panel.visible:
			inv_panel.visible = false
		else:
			inv_panel.visible = true
		if visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			inventory_data.save_inventory()
