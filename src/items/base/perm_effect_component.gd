## Component for permanent effect.
extends Item
class_name PermEffectComponent

@export var additive_modifiers: Dictionary = {}
@export var multiplicative_modifiers: Dictionary = {}

func _apply_effect(actor: Player):
	if not additive_modifiers.is_empty():
		actor.stat_perm_modify(additive_modifiers, 
		GlobalEnums.StatModifierType.Additive)
	
	if not multiplicative_modifiers.is_empty():
		actor.stat_perm_modify(multiplicative_modifiers, 
		GlobalEnums.StatModifierType.Multiplicative)
