## Component for temporary effect.
extends Item
class_name TempEffectComponent

@export var additive_modifiers: Dictionary = {}
@export var multiplicative_modifiers: Dictionary = {}
@export var duration: float = 30.0

func _apply_effect(actor: Player):
	if not additive_modifiers.is_empty():
		actor.stat_temp_modify(additive_modifiers, 
		GlobalEnums.StatModifierType.Additive, duration)
	
	if not multiplicative_modifiers.is_empty():
		actor.stat_temp_modify(multiplicative_modifiers, 
		GlobalEnums.StatModifierType.Multiplicative, duration)
