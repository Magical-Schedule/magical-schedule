class_name Player
extends CharacterBody2D

## --- MOVEMENT & VISUALS ---
var nearby_field: Field = null
@onready var inventory_ui: Control = null
@onready var animated_sprite = $AnimatedSprite2D

## --- SOUND EFFECTS ---
@onready var steps_sfx: AudioStreamPlayer = $Walk_sfx
var step_sounds = [
	preload("res://assets/sounds/korak_suho_1.wav"),
	preload("res://assets/sounds/korak_suho_2.wav"),
	preload("res://assets/sounds/korak_suho_3.wav"),
	preload("res://assets/sounds/korak_suho_4.wav")
]

## --- STATS SYSTEM ---
class StatValue:
	var base: float = 0.0
	var additive_modifier: float = 0.0
	var multiplicative_modifier: float = 1.0
	
	func _init(_base: float):
		self.base = _base
	
	func get_total() -> float:
		if is_equal_approx(multiplicative_modifier, 1.0):
			multiplicative_modifier = 1.0
		return (base + additive_modifier) * multiplicative_modifier

var player_stats: Dictionary = {
	GlobalEnums.Stat.Walk_Speed: StatValue.new(350.0),
	GlobalEnums.Stat.Growth_Speed: StatValue.new(1.0),
	GlobalEnums.Stat.Charisma: StatValue.new(1.0),
	GlobalEnums.Stat.Luck: StatValue.new(1.0),
	GlobalEnums.Stat.Money: StatValue.new(10.0),
}

## --- ENGINE METHODS ---

func _ready() -> void:
	# Find InventoryUI in scene [cite: 51, 54]
	inventory_ui = get_tree().get_first_node_in_group("inventory_ui")
	if not inventory_ui:
		print("⚠️ InventoryUI not found in scene")

func _physics_process(_delta: float) -> void:
	# Movement Logic 
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		# Use stats system for speed [cite: 52]
		var speed = player_stats[GlobalEnums.Stat.Walk_Speed].get_total()
		velocity = direction * speed
		
		_handle_animations(direction)
		_handle_step_sounds()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, player_stats[GlobalEnums.Stat.Walk_Speed].get_total())
		animated_sprite.play("Idle")
		if steps_sfx and steps_sfx.playing:
			steps_sfx.stop() 
		
	move_and_slide()

func _input(event):
	if event.is_action_pressed("interact"):
		interact_with_field()

## --- HELPER METHODS ---

func _handle_animations(direction: Vector2):
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

func _handle_step_sounds():
	if steps_sfx and not steps_sfx.playing:
		var random_index = randi() % step_sounds.size()
		steps_sfx.stream = step_sounds[random_index]
		steps_sfx.pitch_scale = randf_range(1.6, 1.8)
		steps_sfx.play() 

## --- STATS MODIFICATION ---

func get_stat_val(stat_type: GlobalEnums.Stat):
	return player_stats[stat_type].get_total()

func apply_stat_modifiers(stat_modifiers: Dictionary, stat_modifier_type: GlobalEnums.StatModifierType):
	for stat_type in stat_modifiers:
		if not player_stats.has(stat_type): continue
		var mod_val = stat_modifiers[stat_type]
		var player_stat = player_stats[stat_type]
		
		match stat_modifier_type:
			GlobalEnums.StatModifierType.Additive:
				player_stat.additive_modifier += mod_val
			GlobalEnums.StatModifierType.Subtractive:
				player_stat.additive_modifier -= mod_val
			GlobalEnums.StatModifierType.Multiplicative:
				player_stat.multiplicative_modifier *= mod_val
			GlobalEnums.StatModifierType.Divisive:
				if mod_val != 0: player_stat.multiplicative_modifier /= mod_val

## --- INTERACTION LOGIC ---

func interact_with_field():
	if not nearby_field: return
	
	if nearby_field.can_harvest():
		var result = nearby_field.harvest()
		if result.has("item"):
			# Logic to add to inventory goes here 
			if inventory_ui:
				# Example: inventory_ui.add_item(result.item, result.amount)
				pass
	else:
		if nearby_field.state == Field.FieldState.GROWING:
			nearby_field.water()
		else:
			plant_test_crop()

func plant_test_crop():
	if not nearby_field: return
	var test_crop = Crop.new()
	test_crop.crop_name = "blue_plant"
	test_crop.growth_stages = 4
	test_crop.time_per_stage = 2.0
	test_crop.base_yield = 3
	test_crop.harvest_item_name = "blue_flower"
	nearby_field.plant_seed(test_crop)
