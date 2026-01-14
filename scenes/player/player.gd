class_name Player
extends CharacterBody2D

var move_speed: float = 350.0
var nearby_field: Field = null

# Referenca na InventoryUI (za kasneje)
@onready var inventory_ui: Control = null

func _ready() -> void:
	# Najdi InventoryUI v sceni
	inventory_ui = get_tree().get_first_node_in_group("inventory_ui")
	if not inventory_ui:
		print("⚠️ InventoryUI not found in scene - will add to inventory later")

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.normalized()

	velocity = move_speed * direction
	move_and_slide()

func _input(event):
	if event.is_action_pressed("interact"):
		interact_with_field()

func interact_with_field():
	if not nearby_field:
		return

	# Če je polje pripravljeno za harvest
	if nearby_field.can_harvest():
		var result = nearby_field.harvest()
		if result.has("item"):
			print("🌾 Harvested: ", result.amount, "x ", result.item)
			print("⚠️ TODO: Add to inventory system")
	else:
		# Za testiranje - posadi testno rastlino
		plant_test_crop()

func plant_test_crop():
	if not nearby_field:
		return

	# Ustvari test crop
	var test_crop = Crop.new()
	test_crop.crop_name = "blue_plant"
	test_crop.growth_stages = 4
	test_crop.time_per_stage = 2.0 # 2 sekundi za testiranje (namesto 13)
	test_crop.base_yield = 3
	test_crop.harvest_item_name = "blue_flower"

	nearby_field.plant_seed(test_crop)
	print("🌱 Planted test crop!")
