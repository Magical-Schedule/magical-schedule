extends Node2D
class_name Field

enum FieldState { EMPTY, WET, GROWING, READY }

const DRY_POT = "res://assets/plants/pots/dry_pot.png"
const WET_POT = "res://assets/plants/pots/wet_pot.png"

@onready var pot_sprite: Sprite2D = $PotSprite
@onready var plant_sprite:  Sprite2D = $PlantSprite
@onready var interaction_area:  Area2D = $InteractionArea

var state: FieldState = FieldState.EMPTY
var crop: Crop = null

func _ready():
	reset_field()
	plant_sprite.visible = false
	
	# Povečaj sprite-e
	pot_sprite.scale = Vector2(2, 2)
	plant_sprite.scale = Vector2(2, 2)
	
	# Premakni rastlino navzgor
	plant_sprite.position. y = -64
	
	# Poveži signale za detekcijo igralca
	if interaction_area:
		interaction_area.body_entered.connect(_on_player_entered)
		interaction_area.body_exited.connect(_on_player_exited)

func _process(delta):
	if state == FieldState.GROWING and crop:
		if crop.grow(delta):  # Vrne true če se je stage spremenil
			update_plant_sprite()
			if crop.is_mature():
				state = FieldState.READY
				print("✅ Crop is ready for harvest!")

func reset_field():
	state = FieldState.EMPTY
	crop = null
	pot_sprite.texture = load(DRY_POT)
	plant_sprite.visible = false

func plant_seed(crop_data: Crop):
	if state != FieldState.EMPTY: 
		return
	
	crop = crop_data
	state = FieldState.WET
	pot_sprite.texture = load(WET_POT)
	
	# Prikaži prvo fazo rastline
	plant_sprite.visible = true
	update_plant_sprite()
	state = FieldState.GROWING
	print("🌱 Planted:  ", crop.crop_name)

func update_plant_sprite():
	if not crop:
		return
	
	# Nastavi spritesheet frame glede na stage
	plant_sprite.texture = load("res://assets/plants/growing_animations/growing_animations.png")
	plant_sprite.hframes = 4  # 4 faze horizontalno
	plant_sprite.vframes = 4  # 4 različne rastline vertikalno
	
	# TODO: Mapirati crop_name na row index
	# Za zdaj uporabi row 0 (prva rastlina)
	var crop_row: int = 0
	plant_sprite.frame = crop_row * plant_sprite. hframes + crop.current_stage

func can_harvest() -> bool:
	return state == FieldState. READY

func harvest() -> Dictionary:
	if state != FieldState.READY or not crop:
		return {}
	
	# Izračunaj yield (random bonus)
	var yield_amount = crop.base_yield + randi() % 3  # +0 do +2
	
	var result = {
		"item": crop.harvest_item_name,
		"amount": yield_amount
	}
	
	print("🌾 Harvested: ", yield_amount, "x ", crop.harvest_item_name)
	reset_field()
	return result

func _on_player_entered(body):
	if body is Player:
		body.nearby_field = self
		print("🟢 Igralec vstopil v območje polja")

func _on_player_exited(body):
	if body is Player:
		body.nearby_field = null
		print("🔴 Igralec zapustil območje polja")
