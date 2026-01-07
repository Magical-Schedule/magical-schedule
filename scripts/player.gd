class_name Player
extends CharacterBody2D


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
	pass
	
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.normalized()

	velocity = direction * player_stats[GlobalEnums.Stat.Walk_Speed].get_total()
	move_and_slide()
