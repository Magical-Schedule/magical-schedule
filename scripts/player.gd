class_name Player
extends CharacterBody2D

var move_speed: float = 350.0
var nearby_field: Field = null  # ⬅️ Reference na najbližje polje

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	direction = direction.normalized()

	velocity = move_speed * direction
	move_and_slide()

# ⬇️ NOVO - handler za interakcijo
func _input(event):
	if event.is_action_pressed("interact"):
		interact_with_field()

func interact_with_field():
	if not nearby_field:
		print("❌ Ni polja v bližini")
		return
	
	# Če je polje pripravljeno za harvest
	if nearby_field.can_harvest():
		var result = nearby_field.harvest()
		if result.has("item"):
			InventoryManager.add_item(result.item, result.amount)
			print("🌾 Harvested: ", result. amount, "x ", result.item)
	else:
		# Za testiranje - posadi testno rastlino
		# TODO: Later bo to odvisno od selected seed v inventoryu
		plant_test_crop()

func plant_test_crop():
	var test_crop = Crop.new()
	test_crop.crop_name = "blue_plant"
	test_crop.growth_stages = 4
	test_crop.time_per_stage = 2.0  # 2 sekundi na fazo (za hitro testiranje)
	test_crop.base_yield = 2
	test_crop.harvest_item_name = "blue_flower"
	
	nearby_field.plant_seed(test_crop)
	print("🌱 Posajeno:  ", test_crop.crop_name)
