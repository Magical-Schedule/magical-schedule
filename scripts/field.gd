extends Node2D
class_name Field

enum FieldState { EMPTY, WET, GROWING, READY }

const DRY_POT = "res://assets/plants/pots/dry_pot.png"
const WET_POT = "res://assets/plants/pots/wet_pot.png"

const MOISTURE_DECAY := 0.02

# Vizualni parametri stresa
const STRESS_COLOR_MIN := 0.5 

@onready var pot_sprite: Sprite2D = $PotSprite
@onready var plant_sprite: Sprite2D = $PlantSprite
@onready var interaction_area: Area2D = $InteractionArea

@onready var planting_sfx: AudioStreamPlayer = $Plant_sfx
@onready var harvest_sfx: AudioStreamPlayer = $Harvest_sfx

var state: FieldState = FieldState.EMPTY
var crop: Crop = null

# Environmental modifiers
var moisture: float = 1.0        
var light: float = 1.0           
var soil_quality: float = 1.0

func _ready():
	reset_field()
	plant_sprite.visible = false
	
	pot_sprite.scale = Vector2(2.5, 2.5)
	plant_sprite.scale = Vector2(2.5, 2.5)
	
	# Premakni rastlino navzgor
	plant_sprite.position.y = -74
	
	if interaction_area:
		interaction_area.body_entered.connect(_on_player_entered)
		interaction_area.body_exited.connect(_on_player_exited)
		
	var test_crop = Crop.new()
	test_crop.crop_name = "flower" 
	test_crop.time_per_stage = 2.0 
	
	plant_seed(test_crop)

func _process(delta):
	if state == FieldState.GROWING and crop:
		update_environment(delta)
		
		if crop.grow(delta, moisture, light):
			update_plant_sprite()
		
		# posodobi vizualni stres vsako posodobitev
		update_stress_visual()
		
		if crop.is_mature():
			state = FieldState.READY
			print("✅ Crop is ready for harvest!")

# Vizualni prikaz stresa rastline
func update_stress_visual():
	if not crop:
		return
	
	# crop.stress je med 0 in 1
	var stress_value := clamp(crop.stress, 0.0, 1.0)
	var color_factor := lerp(1.0, STRESS_COLOR_MIN, stress_value)
	
	# bolj ko je rastlina pod stresom, bolj je bleda
	plant_sprite.modulate = Color(1.0, color_factor, color_factor)

# Posodabljanje okolja
func update_environment(delta: float):
	moisture = max(0.0, moisture - MOISTURE_DECAY * delta)
	update_pot_visual()

# Vizualni prikaz vlažnosti
func update_pot_visual():
	if moisture > 0.3:
		pot_sprite.texture = load(WET_POT)
	else:
		pot_sprite.texture = load(DRY_POT)

func reset_field():
	state = FieldState.EMPTY
	crop = null
	moisture = 1.0
	soil_quality = 1.0
	pot_sprite.texture = load(DRY_POT)
	plant_sprite.visible = false

func plant_seed(crop_data: Crop):
	if state != FieldState.EMPTY: 
		return
	
	crop = crop_data
	state = FieldState.WET
	moisture = 1.0
	pot_sprite.texture = load(WET_POT)
	
		
	plant_sprite.visible = true
	update_plant_sprite()
	if planting_sfx:
		planting_sfx.play()
		await get_tree().create_timer(0.5).timeout
		planting_sfx.stop()
	state = FieldState.GROWING
	print("🌱 Planted: ", crop.crop_name)

func update_plant_sprite():
	if not crop:
		return
	
	plant_sprite.texture = load("res://assets/plants/growing_animations/growing_animations.png")
	
	plant_sprite.hframes = 4 
	plant_sprite.vframes = 4 
	
	var crop_row: int = 0
	plant_sprite.frame = crop_row * plant_sprite.hframes + crop.current_stage

	# Vizualni vpliv suše
	plant_sprite.modulate = Color(1, moisture, moisture)

func can_harvest() -> bool:
	return state == FieldState.READY

func harvest() -> Dictionary:
	if state != FieldState.READY or not crop:
		return {}
	

	if harvest_sfx:
		harvest_sfx.play()

	
	# Izračunaj yield (random bonus)
	var yield_amount := int((crop.base_yield + randi() % 3) * soil_quality)
	
	var result = {
		"item": crop.harvest_item_name,
		"amount": yield_amount
	}
	
	print("🌾 Harvested: ", yield_amount, "x ", crop.harvest_item_name)
	reset_field()
	return result

# Zalivanje
func water(amount := 0.4):
	moisture = min(1.0, moisture + amount)
	update_pot_visual()

# Gnojenje
func fertilize(amount := 0.2):
	soil_quality = min(1.5, soil_quality + amount)

func _on_player_entered(body):
	if body is Player:
		body.nearby_field = self
		print("🟢 Igralec vstopil v območje polja")

func _on_player_exited(body):
	if body is Player:
		body.nearby_field = null
		print("🔴 Igralec zapustil območje polja")
		
func _unhandled_input(event):
	if event is InputEventKey and event.keycode == KEY_E and event.pressed:
		if state == FieldState.READY:
			for body in interaction_area.get_overlapping_bodies():
				if body is Player:
					execute_harvest()

func execute_harvest():
	var result = harvest()
	if not result.is_empty():
		var inv_ui = get_tree().root.find_child("InventoryUi", true, false)
		if inv_ui:
			var item_path = "res://scripts/items/Define/" + result.item + ".tres"
			
			if ResourceLoader.exists(item_path):
				var item_resource = load(item_path)
				inv_ui.add_item(item_resource, result.amount)
				print("✅ Uspešno ubrano: ", result.item)
			else:
				print("❌ Nedostaje resurs: ", item_path)
				
#update
