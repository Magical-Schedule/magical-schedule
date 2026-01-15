extends Node2D
class_name Field

# --- States & Constants ---
enum FieldState { EMPTY, GROWING, READY }

const DRY_POT = "res://assets/plants/pots/dry_pot.png"
const WET_POT = "res://assets/plants/pots/wet_pot.png"
const MOISTURE_DECAY := 0.02

# --- Node References ---
@onready var pot_sprite: Sprite2D = $PotSprite
@onready var plant_sprite: Sprite2D = $PlantSprite
@onready var proximity_area: Area2D = $InteractionArea # This is your trigger zone
@onready var prompt_ui: Control = $UI  # The floating "F" prompt
<<<<<<< HEAD
var current_crop_row: int = 0
var current_growth_texture: Texture2D
=======
>>>>>>> player-idle-breathing

# SFX
@onready var planting_sfx: AudioStreamPlayer = get_node_or_null("Plant_sfx")
@onready var harvest_sfx: AudioStreamPlayer = get_node_or_null("Harvest_sfx")

# --- Variables (From WorldObject) ---
var player_in_range := false
var player: CharacterBody2D = null

# --- Variables (From Field) ---
var state: FieldState = FieldState.EMPTY
var crop: Crop = null
var moisture: float = 1.0  
var light: float = 1.0            
var soil_quality: float = 1.0

func _ready():
	# Initial Setup
	reset_field()
	prompt_ui.visible = false
	
	pot_sprite.scale = Vector2(2.5, 2.5)
	plant_sprite.scale = Vector2(2.5, 2.5)
	plant_sprite.position.y = -74 # Moves plant above pot
	
	# Connect Proximity Signals (WorldObject Style)
	proximity_area.body_entered.connect(_on_body_entered)
	proximity_area.body_exited.connect(_on_body_exited)

func _process(delta):
	if state == FieldState.GROWING and crop:
		update_environment(delta)
		
		# Grow logic returns true when stage increases
		if crop.grow(delta, moisture, light):
			update_plant_sprite()
			if crop.is_mature():
				state = FieldState.READY
				if player_in_range:
					update_ui_text("Press F to Harvest")

func _unhandled_input(event):
<<<<<<< HEAD
	if player_in_range and event.is_action_pressed("interact"):
		if state == FieldState.EMPTY:
			var inv_ui = get_tree().get_first_node_in_group("inventory_group") # Uporabi skupino!
			if inv_ui:
				var selected_item = inv_ui.check_item()
				if selected_item is ItemData and selected_item.is_seed:
					start_planting(selected_item)
					inv_ui.get_item_from_active()
					inv_ui.populate_grids() # Osveži prikaz po sajenju
					get_viewport().set_input_as_handled()
		
		# DODAJ TA DEL ZA HARVEST:
=======
	# Using "interact" (F) - check Project Settings > Input Map
	if player_in_range and event.is_action_pressed("interact"):
		if state == FieldState.EMPTY:
			start_planting()
			get_viewport().set_input_as_handled()
>>>>>>> player-idle-breathing
		elif state == FieldState.READY:
			execute_harvest()
			get_viewport().set_input_as_handled()

<<<<<<< HEAD
func start_planting(seed_data: ItemData):
	if not seed_data: return
	
	var new_crop = Crop.new()
	
	# Očistimo ime: odstranimo "_seed" ali " seed", da dobimo ime pridelka
	var clean_harvest_name = seed_data.name.to_lower().replace("_seed", "").replace(" seed", "").strip_edges()
	
	new_crop.crop_name = clean_harvest_name
	new_crop.harvest_item_name = clean_harvest_name # Zdaj bo mushroom namesto mushroom_seed
	new_crop.time_per_stage = 2.0 

	current_growth_texture = seed_data.growth_spritesheet
	current_crop_row = seed_data.crop_row_index 
	
	plant_seed(new_crop)
	
=======
# --- Core Logic ---

func start_planting():
	# Create test crop
	var test_crop = Crop.new()
	test_crop.crop_name = "flower" 
	test_crop.time_per_stage = 2.0 
	test_crop.harvest_item_name = "flower"
	
	plant_seed(test_crop)
>>>>>>> player-idle-breathing

func plant_seed(crop_data: Crop):
	crop = crop_data
	state = FieldState.GROWING
	moisture = 1.0
	pot_sprite.texture = load(WET_POT)
	
	plant_sprite.visible = true
	update_plant_sprite()
	
	if planting_sfx:
		planting_sfx.play()
<<<<<<< HEAD
		await get_tree().create_timer(0.5).timeout
		planting_sfx.stop()
=======
>>>>>>> player-idle-breathing
	
	update_ui_text("Growing...")

func execute_harvest():
	if state != FieldState.READY or not crop:
		return

<<<<<<< HEAD
	var yield_amount := int((crop.base_yield + randi() % 3) * soil_quality)
	var inv_ui = get_tree().get_first_node_in_group("inventory_group")

	if inv_ui:
		var final_file_name = crop.harvest_item_name.to_lower().strip_edges()
		
		
		var item_path = "res://scripts/items/Define/" + final_file_name + ".tres"
		
		print("DEBUG: Iščem pridelek na poti: ", item_path)

		if ResourceLoader.exists(item_path):
			var item_resource = load(item_path)
			inv_ui.add_item(item_resource, yield_amount)
			if harvest_sfx: harvest_sfx.play()
			print("SISTEM: Pridelek uspešno dodan: ", final_file_name)
		else:
			print("NAPAKA: Datoteka pridelka ne obstaja: ", item_path)
=======
	if harvest_sfx:
		harvest_sfx.play()

	var yield_amount := int((crop.base_yield + randi() % 3) * soil_quality)
	
	# Inventory Logic
	var inv_ui = get_tree().root.find_child("InventoryUi", true, false)
	if inv_ui:
		var item_path = "res://scripts/items/Define/" + crop.harvest_item_name + ".tres"
		if ResourceLoader.exists(item_path):
			var item_resource = load(item_path)
			inv_ui.add_item(item_resource, yield_amount)
>>>>>>> player-idle-breathing
	
	reset_field()
	if player_in_range:
		update_ui_text("Press F to Plant")

<<<<<<< HEAD
		
=======
>>>>>>> player-idle-breathing
func reset_field():
	state = FieldState.EMPTY
	crop = null
	moisture = 1.0
	pot_sprite.texture = load(DRY_POT)
	plant_sprite.visible = false

# --- Visuals & Environment ---

func update_environment(delta: float):
	moisture = max(0.0, moisture - MOISTURE_DECAY * delta)
	pot_sprite.texture = load(WET_POT) if moisture > 0.3 else load(DRY_POT)

func update_plant_sprite():
<<<<<<< HEAD
	if not crop or not current_growth_texture: return
	
	plant_sprite.texture = current_growth_texture

	if current_growth_texture.get_height() < 40:
		plant_sprite.position.y = -37  # Vrednost za gobe (prilagodi po občutku)
	else:
		plant_sprite.position.y = -74
		
	plant_sprite.hframes = 4 
	
	if current_growth_texture.get_height() > 40:
		plant_sprite.vframes = 4
	else:
		plant_sprite.vframes = 1 # Za gobo, ki je visoka le 32px

	
	var row = current_crop_row
	if plant_sprite.vframes == 1:
		row = 0
		
	# Izračun končnega frejma
	var target_frame = (row * plant_sprite.hframes) + crop.current_stage
	
	# Preverimo, da frame fizično obstaja na naloženi sliki
	var total_possible_frames = plant_sprite.hframes * plant_sprite.vframes
	if target_frame < total_possible_frames:
		plant_sprite.frame = target_frame
	else:
		# Če pride do napake, postavi na prvi frame, da ne sesuje igre
		plant_sprite.frame = 0 
		print("Opozorilo: Poskus dostopa do neobstoječega frejma na sliki!")

=======
	if not crop: return
	plant_sprite.texture = load("res://assets/plants/growing_animations/growing_animations.png")
	plant_sprite.hframes = 4 
	plant_sprite.vframes = 4 
	
	var crop_row: int = 0
	plant_sprite.frame = crop_row * plant_sprite.hframes + crop.current_stage
>>>>>>> player-idle-breathing
	plant_sprite.modulate = Color(1, moisture, moisture)

func update_ui_text(new_text: String):
	# This finds the "Label" inside your UI structure
	var label = prompt_ui.find_child("Label", true)
	if label:
		label.text = new_text

# --- Proximity Signals (WorldObject Logic) ---

func _on_body_entered(body):
	if body is CharacterBody2D:
		player = body
		player_in_range = true
		prompt_ui.visible = true
		
		# Set text based on current state
		if state == FieldState.EMPTY:
			update_ui_text("Press F to Plant")
		elif state == FieldState.READY:
			update_ui_text("Press F to Harvest")
		else:
			update_ui_text("Growing...")

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		player = null
		prompt_ui.visible = false
