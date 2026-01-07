extends Control

@export var slot_scene: PackedScene
@onready var hotbar_panel = $HotbarPanel
@onready var hotbar_grid = $HotbarPanel/VBoxContainer/HotbarGrid
@onready var inv_panel = $InventoryPanel
@onready var inv_grid = $InventoryPanel/VBoxContainer/InventoryGrid

var inventory_data: InventoryData
var focus_in_backpack: bool = true
var focused_index: int = 0

## Adding Item	
func add_item(item: Item, count: int = 1) -> bool:
	# Search Hotbar first, then Backpack
	var all_slots = inventory_data.hotbar_slots + inventory_data.backpack_slots
	
	# 1. Try to find an existing stack
	for slot in all_slots:
		if slot.item_data and slot.item_data.resource_path == item.resource_path:
			var q_data = slot.item_data.quantity_data
			if q_data and q_data.max_stack > 1:
				q_data.current_stack += count
				slot.inventory_updated.emit() # Refresh UI
				return true

	# 2. Find first empty slot
	for slot in all_slots:
		if slot.item_data == null:
			# Duplicate to ensure unique quantity components
			slot.item_data = item.duplicate(true)
			slot.item_data.quantity_data.current_stack = count
			return true
	
	return false

func use_active_item(actor: Player):
	var slot = inventory_data.hotbar_slots[inventory_data.active_slot_index]
	
	if slot and slot.item_data:
		# This calls _apply_effect and _handle_consumption in one go
		var still_exists = slot.item_data.use_item(actor)
		
		if not still_exists:
			slot.item_data = null # Triggers UI update via SlotData setter

func update_hotbar_visuals():
	# Preverimo, če hotbar sploh ima otroke, da ne pride do napake
	if hotbar_grid.get_child_count() > 0:
		for i in range(hotbar_grid.get_child_count()):
			var slot = hotbar_grid.get_child(i)
			
			# set_highlight mora biti definiran v InventorySlot.gd
			# Pass transparency values to the highlight function
			slot.set_highlight(
				i == inventory_data.active_slot_index, 
				inventory_data.active_transparency, 
				inventory_data.inactive_transparency
			)

func change_active_slot(direction: int):
	# wrapi(trenutna_vrednost, min, max) 
	# Hotbar ima 8 slotov (indeksi 0 do 7)
	inventory_data.active_slot_index = wrapi(
		inventory_data.active_slot_index + direction, 0, InventoryData.WIDTH)
	update_hotbar_visuals()



func update_focus_visuals():
	# Reset all highlights in both grids
	for slot in inv_grid.get_children():
		slot.set_highlight(false, inventory_data.active_transparency, inventory_data.inactive_transparency)
	for slot in hotbar_grid.get_children():
		slot.set_highlight(false, inventory_data.active_transparency, inventory_data.inactive_transparency)

	# Highlight the specific focused slot
	var target_grid = inv_grid if focus_in_backpack else hotbar_grid
	if target_grid.get_child_count() > focused_index:
		var slot = target_grid.get_child(focused_index)
		# Pass true to show the selection frame
		slot.set_highlight(true, inventory_data.active_transparency, inventory_data.inactive_transparency)

## Navigiranje Inventorijem
func _navigate_grid(direction: Vector2i):
	var width = InventoryData.WIDTH
	
	if focus_in_backpack:
		var row = focused_index / width
		var col = focused_index % width
		
		# Horizontal movement
		col = clampi(col + direction.x, 0, width - 1)
		
		# Vertical movement
		row += direction.y
		
		if row < 0: # Stay at top of backpack
			row = 0
		elif row >= InventoryData.BACKPACK_HEIGHT: # Jump to Hotbar
			focus_in_backpack = false
			focused_index = col # Keep the same column
			update_focus_visuals()
			return
			
		focused_index = (row * width) + col
	else:
		# Navigation inside Hotbar (usually 1 row)
		focused_index = clampi(focused_index + direction.x, 0, width - 1)
		
		if direction.y < 0: # Jump back to Backpack
			focus_in_backpack = true
			focused_index = ((InventoryData.BACKPACK_HEIGHT - 1) * width) + focused_index
			
	update_focus_visuals()

## Sledenje input-a
func _input(event):
	# Mouse Mode
	if event.is_action_pressed("inventory_toggle"): 
		inv_panel.visible = !inv_panel.visible 
		
		if inv_panel.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			inventory_data.save_inventory()
	
	"""
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			change_active_slot(-1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			change_active_slot(1)
	"""
	
	# Determine the "Vector" of the move
	var move = Vector2i.ZERO
			
	if event.is_action_pressed("ui_left"):  move.x = -1
	if event.is_action_pressed("ui_right"): move.x = 1
	elif inv_panel.visible: # Only navigate if the backpack is open
		if event.is_action_pressed("ui_up"):   move.y = -1
		if event.is_action_pressed("ui_down"): move.y = 1
	
	# If we actually pressed a direction, run the logic
	if move != Vector2i.ZERO:
		_navigate_grid(move)
	
	"""
	if event.is_action_pressed("ui_accept"): # Usually Space/Enter
		var target_grid = inv_grid if focus_in_backpack else hotbar_grid
		var slot = target_grid.get_child(focused_index)
		# Now you can call use_item() or quick_move() on that slot!
	"""

func populate_grids():
	for child in inv_grid.get_children(): child.queue_free()
	for child in hotbar_grid.get_children(): child.queue_free()

	# Fill Hotbar Grid
	for i in inventory_data.hotbar_slots.size():
		var slot_visual = slot_scene.instantiate()
		hotbar_grid.add_child(slot_visual)
		slot_visual.set_slot_data(inventory_data.hotbar_slots[i])
		# Apply the pattern 
		slot_visual.apply_visuals(inventory_data.slot_background, 
			inventory_data.inactive_transparency,
			inventory_data.slot_size)

	# Fill Backpack Grid
	for i in inventory_data.backpack_slots.size():
		var slot_visual = slot_scene.instantiate()
		inv_grid.add_child(slot_visual)
		slot_visual.set_slot_data(inventory_data.backpack_slots[i])
		# Apply the pattern 
		slot_visual.apply_visuals(inventory_data.slot_background, 
			inventory_data.inactive_transparency,
			inventory_data.slot_size)
	
	update_hotbar_visuals()

func _ready():
	print("Creating Inventories")
	inventory_data = InventoryData.load_or_create()
	inv_panel.visible = false 
	hotbar_panel.visible = true
	
	add_item(load("res://data/items/seeds/seed_mushroom.tres"))
	populate_grids()
