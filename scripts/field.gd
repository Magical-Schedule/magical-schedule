extends Node2D  # ali Area2D če rabi kolizijo
class_name Field

enum FieldState { EMPTY, WET, GROWING, READY_TO_HARVEST }

# Nodes (poveži v sceni)
@onready var pot_sprite: Sprite2D = $PotSprite
@onready var plant_sprite: Sprite2D = $PlantSprite
@onready var interaction_area:  Area2D = $InteractionArea

# State
var state: FieldState = FieldState.EMPTY
var crop:  Crop = null

# Sprite paths
const DRY_POT = "res://assets/plants/pots/dry_pot.png"
const WET_POT = "res://assets/plants/pots/wet_pot.png"

# Spritesheet settings (prilagodi glede na velikost tvojih sprite-ov)
var sprite_width: int = 32  # širina enega frame-a v pixlih
var sprite_height: int = 32

func _ready():
	reset_field()
	plant_sprite.visible = false
	
	# Poveži signale za detekcijo igralca
	if interaction_area:
		interaction_area.body_entered.connect(_on_player_entered)
		interaction_area.body_exited.connect(_on_player_exited)

func _process(delta):
	if state == FieldState.GROWING and crop:
		if crop.grow(delta):
			update_plant_sprite()
			if crop.is_mature():
				state = FieldState.READY_TO_HARVEST

func plant_seed(crop_data:  Crop):
	if state != FieldState.EMPTY:
		return
	
	crop = crop_data
	state = FieldState.WET
	pot_sprite.texture = load(WET_POT)
	
	# Prikaži prvo fazo rastline
	plant_sprite.visible = true
	update_plant_sprite()
	state = FieldState.GROWING

func update_plant_sprite():
	# Nastavi frame glede na fazo rasti
	# Primer: če je spritesheet horizontalen 4x1
	plant_sprite.texture = load("res://assets/plants/growing_animations/growing_animations.png")
	plant_sprite.hframes = 4  # 4 faze horizontalno
	plant_sprite.vframes = 4  # 4 rastline vertikalno (prilagodi!)
	
	# Izberi pravo vrstico (crop type) in stolpec (stage)
	var crop_row: int = 0  # TODO: mapirati crop type na row
	plant_sprite.frame = crop_row * plant_sprite.hframes + crop. current_stage

func harvest() -> Dictionary:
	if state != FieldState.READY_TO_HARVEST or not crop:
		return {}
	
	# Izračunaj yield (random bonus)
	var yield_amount = crop.base_yield + randi() % 3  # +0 do +2
	
	var result = {
		"item": crop.harvest_item_name,
		"amount": yield_amount
	}
	
	reset_field()
	return result

func reset_field():
	state = FieldState.EMPTY
	crop = null
	pot_sprite.texture = load(DRY_POT)
	plant_sprite.visible = false

# Za interakcijo z igralcem
func can_harvest() -> bool:
	return state == FieldState.READY_TO_HARVEST

# Dodaj nove funkcije na konec:
func _on_player_entered(body):
	if body is Player:
		body.nearby_field = self
		print("🟢 Igralec vstopil v območje polja")

func _on_player_exited(body):
	if body is Player:
		body.nearby_field = null
		print("🔴 Igralec zapustil območje polja")
