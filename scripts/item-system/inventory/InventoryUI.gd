extends Control

@export var slot_scene: PackedScene
@onready var inv_grid = $Panel/VBoxContainer/InventoryGrid
@onready var hotbar_grid = $Panel2/VBoxContainer/HotbarGrid

@onready var inv_panel = $Panel
@onready var hotbar_panel = $Panel2

var sell = false
var inventory_data: InventoryData


func _ready():
	print("creating inventory")
	inventory_data = InventoryData.load_or_create()
	inv_panel.visible = false 
	hotbar_panel.visible = true
	
	# add_item(load("res://scripts/items/Define/mushroom.tres"))
	# add_item(load("res://scripts/items/Define/mushroom_seed.tres"))
	# add_item(load("res://data/items/yields/yield_mushroom.tres"))
	# add_item(load("res://data/items/seeds/seed_mushroom.tres"))
	populate_grids()
	
## Populating Grids
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
	update_hotbar_visuals()
	
## Input Processing
func _input(event):
	if event.is_action_pressed("inventory_toggle"): 
		sell = false
		inv_panel.visible = !inv_panel.visible 
		
		if inv_panel.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			inventory_data.save_inventory()

	if event.is_action_pressed("inventory_left"):
		change_active_slot(-1)
	elif event.is_action_pressed("inventory_right"):
		change_active_slot(1)

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			change_active_slot(-1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			change_active_slot(1)
			
func add_item(item: Item, count: int = 1):
	var search_order = []
	for i in range(54, 63): search_order.append(i) 
	for i in range(0, 54): search_order.append(i)

	# print(str(item.quantity_data.max_stack) + " >= 1: " 
	#	+ ("true" if item.quantity_data.max_stack >= 1 else "false"))

	# 1. Stacking logic
	if item.quantity_data.max_stack >= 1:
		for i in search_order:
			var slot = inventory_data.slots[i]
			
			if slot.item_data == null: continue;
			
			print(slot.item_data.name + " == " + item.name + ": " 
				+ ("true" if slot.item_data.name == item.name else "false"))
			
			if slot.item_data.name == item.name:
				var remaining_space = item.quantity_data.max_uses - slot.quantity
				
				print("count = " + str(count))
				print("remaining_space = " + 
					str(item.quantity_data.max_uses)
					+ " - " + str(slot.quantity)
					+ " = " + str(remaining_space))
					
				if remaining_space > 0:
					var amount_to_add = min(count, remaining_space)
					
					print("amount_to_add = " + str(amount_to_add))
					
					slot.quantity += amount_to_add
					count -= amount_to_add
					
					if count <= 0: 
						populate_grids() # Update UI once after logic finishes
						return true 

	# 2. Find empty slot for REMAINDER of items
	if count > 0:
		for i in search_order:
			var slot = inventory_data.slots[i]
			if slot.item_data == null:
				slot.item_data = item
				slot.quantity = count
				populate_grids()
				return true
	
	return false

func update_hotbar_visuals():
	# Preverimo, če hotbar sploh ima otroke, da ne pride do napake
	if hotbar_grid.get_child_count() > 0:
		for i in range(hotbar_grid.get_child_count()):
			var slot = hotbar_grid.get_child(i)
			# set_highlight mora biti definiran v InventorySlot.gd
			slot.set_highlight(i == inventory_data.active_slot_index)

func change_active_slot(direction: int):
	# wrapi(trenutna_vrednost, min, max) 
	# Hotbar ima 9 slotov (indeksi 0 do 8)
	inventory_data.active_slot_index = wrapi(inventory_data.active_slot_index + direction, 0, 9)
	update_hotbar_visuals()
	
func check_item():
	return inventory_data.slots[54+inventory_data.active_slot_index].item_data
	
func get_item_from_active():
	if inventory_data.slots[54+inventory_data.active_slot_index].item_data != null:
		inventory_data.slots[54+inventory_data.active_slot_index].quantity-=1
		
func set_visible_iu():
	var ui = get_tree().root.find_child("InventorySlot", true, false)
	inv_panel.visible = !inv_panel.visible 
	
	if inv_panel.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		inventory_data.save_inventory()

func toggle_sell():
	if sell:
		sell=false
	else:
		sell = true
