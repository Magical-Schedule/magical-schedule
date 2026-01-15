extends Node2D
class_name Field

# --- States & Constants ---
enum FieldState { EMPTY, GROWING, READY }

const DRY_POT = "res://assets/textures/plants/pots/dry_pot.png"
const WET_POT = "res://assets/textures/plants/pots/wet_pot.png"
const MOISTURE_DECAY := 0.02

# --- Node References ---
@onready var pot_sprite: Sprite2D = $PotSprite
@onready var plant_sprite: Sprite2D = $PlantSprite
@onready var proximity_area: Area2D = $InteractionArea # This is your trigger zone
@onready var prompt_ui: Control = $UI  # The floating "F" prompt

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
	# Using "interact" (F) - check Project Settings > Input Map
	if player_in_range and event.is_action_pressed("interact"):
		if state == FieldState.EMPTY:
			start_planting()
			get_viewport().set_input_as_handled()
		elif state == FieldState.READY:
			execute_harvest()
			get_viewport().set_input_as_handled()

# --- Core Logic ---

func start_planting():
	# Create test crop
	var test_crop = Crop.new()
	test_crop.crop_name = "flower" 
	test_crop.time_per_stage = 2.0 
	test_crop.harvest_item_name = "flower"
	
	plant_seed(test_crop)

func plant_seed(crop_data: Crop):
	crop = crop_data
	state = FieldState.GROWING
	moisture = 1.0
	pot_sprite.texture = load(WET_POT)
	
	plant_sprite.visible = true
	update_plant_sprite()
	
	if planting_sfx:
		planting_sfx.play()
	
	update_ui_text("Growing...")

func execute_harvest():
	if state != FieldState.READY or not crop:
		return

	if harvest_sfx:
		harvest_sfx.play()

	var yield_amount := int((crop.base_yield + randi() % 3) * soil_quality)
	
	# Inventory Logic
	var inv_ui = get_tree().root.find_child("InventoryUI", true, false)
	if inv_ui:
		var item_path = "res://scripts/items/Define/" + crop.harvest_item_name + ".tres"
		if ResourceLoader.exists(item_path):
			var item_resource = load(item_path)
			inv_ui.add_item(item_resource, yield_amount)
	
	reset_field()
	if player_in_range:
		update_ui_text("Press F to Plant")

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
	if not crop: return
	plant_sprite.texture = load("res://assets/textures/plants/growing_animations/growing_animations.png")
	plant_sprite.hframes = 4 
	plant_sprite.vframes = 4 
	
	var crop_row: int = 0
	plant_sprite.frame = crop_row * plant_sprite.hframes + crop.current_stage
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
