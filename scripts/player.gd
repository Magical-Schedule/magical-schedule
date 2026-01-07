class_name Player
extends CharacterBody2D

var move_speed:  float = 350.0
var nearby_field: Field = null

# Referenca na InventoryUI (za kasneje)
@onready var inventory_ui: Control = null

	## STATS
	
## StatValue Class for Player
class StatValue:
	var base: float = 0.0
	var additive_modifier: float = 0.0
	var multiplicative_modifier: float = 1.0
	
	func _init(_base: float):
		self.base = _base
	
	func get_total() -> float:
		# If the multiplier is approximate to 1, just snap it to 1
		if is_equal_approx(multiplicative_modifier, 1.0):
			multiplicative_modifier = 1.0
		return (base + additive_modifier) * multiplicative_modifier

var player_stats: Dictionary = {
	# GlobalEnums.Stat.Max_Health: StatValue.new(100.0),
	GlobalEnums.Stat.Walk_Speed: StatValue.new(350.0),
	GlobalEnums.Stat.Growth_Speed: StatValue.new(1.0),
	GlobalEnums.Stat.Charisma: StatValue.new(1.0),
	GlobalEnums.Stat.Luck: StatValue.new(1.0),
	GlobalEnums.Stat.Money: StatValue.new(10.0),
}

func get_stat_val(stat_type: GlobalEnums.Stat):
	return player_stats[stat_type].base

## [Player] Stats Modifiying Methods
func set_inverse_modifier_type(stat_modifier_type: GlobalEnums.StatModifierType) -> GlobalEnums.StatModifierType:	
	match stat_modifier_type:
		GlobalEnums.StatModifierType.Additive:
			return GlobalEnums.StatModifierType.Subtractive
		GlobalEnums.StatModifierType.Subtractive:
			return GlobalEnums.StatModifierType.Additive
		GlobalEnums.StatModifierType.Multiplicative:
			return GlobalEnums.StatModifierType.Divisive
		GlobalEnums.StatModifierType.Divisive:
			return GlobalEnums.StatModifierType.Multiplicative
	return GlobalEnums.StatModifierType.Unknown

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
				# Prevent division by zero just in case!
				if mod_val != 0:
					player_stat.multiplicative_modifier /= mod_val
		
func apply_perm_stat_modifiers(stat_modifiers: Dictionary, stat_modifier_type: GlobalEnums.StatModifierType):
	apply_stat_modifiers(stat_modifiers, stat_modifier_type)

func apply_temp_stat_modifiers(stat_modifiers: Dictionary, stat_modifier_direct_type: GlobalEnums.StatModifierType, duration: float):
	var stat_modifier_inverse_type: GlobalEnums.StatModifierType = set_inverse_modifier_type(stat_modifier_direct_type)	
	apply_stat_modifiers(stat_modifiers, stat_modifier_direct_type)
	
	# Wait, then undo the exact same modification
	await get_tree().create_timer(duration).timeout
	
	if is_instance_valid(self):
		apply_stat_modifiers(stat_modifiers, stat_modifier_inverse_type)


	## MONEY

## Method for picking up coins or paying for items
func modify_money_balance(amount: float):
	# This method changes the base of Money stat
	# Positive amount = Income, Negative amount = Spending
	apply_perm_stat_modifiers({GlobalEnums.Stat.Money: amount}, GlobalEnums.StatModifierType.Additive)

## Method to check if the player can afford something
func can_afford(price: float) -> bool:
	return get_stat_val(GlobalEnums.Stat.Money) >= price

# ALL NON-GAME ENGINE METHODS GO BEFORE


	## Game Engine Methods
	
func _ready() -> void:
	# Najdi InventoryUI v sceni
	inventory_ui = get_tree().get_first_node_in_group("inventory_ui")
	if not inventory_ui:
		print("⚠️ InventoryUI not found in scene - will add to inventory later")

func _physics_process(_delta:  float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input. get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.normalized()

	velocity = direction * player_stats[GlobalEnums.Stat.Walk_Speed].get_total()
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
		if result. has("item"):
			print("🌾 Harvested:  ", result.amount, "x ", result.item)
			print("⚠️ TODO:  Add to inventory system")
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
