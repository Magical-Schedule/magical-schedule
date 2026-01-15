class_name Player
extends CharacterBody2D

var move_speed:  float = 350.0
var nearby_field: Field = null

# Referenca na InventoryUI (za kasneje)
@onready var inventory_ui: Control = null
@onready var animated_sprite = $AnimatedSprite2D

<<<<<<< HEAD

=======
>>>>>>> player-idle-breathing
@onready var steps_sfx: AudioStreamPlayer = $Walk_sfx

var step_sounds = [
	preload("res://assets/sounds/korak_suho_1.wav"),
	preload("res://assets/sounds/korak_suho_2.wav"),
	preload("res://assets/sounds/korak_suho_3.wav"),
	preload("res://assets/sounds/korak_suho_4.wav")
]

func _ready() -> void:
	# Najdi InventoryUI v sceni
	inventory_ui = get_tree().get_first_node_in_group("inventory_ui")
	if not inventory_ui:
		print("⚠️ InventoryUI not found in scene - will add to inventory later")
<<<<<<< HEAD
	
=======
>>>>>>> player-idle-breathing

func play_random_step():
	if steps_sfx == null or step_sounds.is_empty():
		return
		
	# Izberi naključen zvok iz seznama
	var random_index = randi() % step_sounds.size()
	steps_sfx.stream = step_sounds[random_index]
	
	# Malo spremeni pitch, da se čuje normalno
	steps_sfx.pitch_scale = randf_range(1.6, 1.8)
	steps_sfx.play()
	
func _physics_process(_delta:  float) -> void:

	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		velocity = direction * move_speed
		
		if steps_sfx and not steps_sfx.playing:
			play_random_step()
			
		if abs(direction.x) > abs(direction.y):
			animated_sprite.play("Walking")
			animated_sprite.flip_h = direction.x < 0
		else:
			if direction.y > 0:
				animated_sprite.play("walking-down")
			else:
				animated_sprite.play("walking-up")
		if direction.y != 0 and direction.x == 0:
			animated_sprite.flip_h = false
	
	else:
		velocity = velocity.move_toward(Vector2.ZERO, move_speed)
		animated_sprite.play("Idle")
		
		if steps_sfx and steps_sfx.playing:
			steps_sfx.stop()
		
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
			print("🌾 Harvested:  ", result.amount, "x ", result.item)
			print("⚠️ TODO:  Add to inventory system")
	else:
		# Za zdaj: zalivanje ali sajenje (testno)
		if nearby_field.state == Field.FieldState.GROWING:
			nearby_field.water()
			print("💧 Polje zalito")
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
	test_crop.time_per_stage = 2.0  # 2 sekundi za testiranje (namesto 13)
	test_crop.base_yield = 3
	test_crop.harvest_item_name = "blue_flower"
	
	nearby_field.plant_seed(test_crop)
	print("🌱 Planted test crop!")
