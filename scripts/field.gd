extends Node2D
class_name Field

enum FieldState { EMPTY, WET, GROWING, READY }

const DRY_POT = "res://assets/plants/pots/dry_pot.png"
const WET_POT = "res://assets/plants/pots/wet_pot.png"

@onready var pot_sprite: Sprite2D = $PotSprite
@onready var plant_sprite: Sprite2D = $PlantSprite
@onready var interaction_area: Area2D = $InteractionArea

var state: FieldState = FieldState.EMPTY
var crop: Crop = null

func _ready():
	reset_field()
	plant_sprite.visible = false
	
	pot_sprite.scale = Vector2(2.5, 2.5)
	plant_sprite.scale = Vector2(2.5, 2.5)
	
	plant_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
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
		if crop.grow(delta):
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
	
	plant_sprite.visible = true
	update_plant_sprite()
	state = FieldState.GROWING
	print("🌱 Planted: ", crop.crop_name)

func update_plant_sprite():
	if not crop:
		return
	
	plant_sprite.texture = load("res://assets/plants/growing_animations/growing_animations.png")
	
	plant_sprite.hframes = 4 
	plant_sprite.vframes = 4 
	
	var crop_row: int = 0
	if crop.crop_name == "carnivorous": crop_row = 1
	elif crop.crop_name == "tree": crop_row = 2
	elif crop.crop_name == "flower": crop_row = 3
	
	plant_sprite.frame = (crop_row * plant_sprite.hframes) + crop.current_stage
	plant_sprite.visible = true

func can_harvest() -> bool:
	return state == FieldState.READY

func harvest() -> Dictionary:
	if state != FieldState.READY or not crop:
		return {}
	
	var yield_amount = crop.base_yield + randi() % 3
	
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
