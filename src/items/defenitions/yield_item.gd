## Base class for all yields.
extends Item
class_name YieldItem

## The base price before any market modifiers or charisma buffs
@export var nominal_value: float = 10.0

## Optional: How fresh/good this specific item is (0.0 to 1.0)
## @export_range(0.0, 1.0) var quality: float = 1.0

## Is this yield edible? (If true, it has EffectData)
## @export var is_edible: bool = false
## @export var temp_effect: TempEffectComponent

## func _apply_effect(actor: Player):
##	if is_edible: effect._apply_effect(actor)

func _init() -> void:
	description = "A fresh harvest from your garden."
