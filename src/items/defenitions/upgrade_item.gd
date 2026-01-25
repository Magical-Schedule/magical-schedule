## Base class for all upgrades.
extends Item
class_name UpgradeItem

@export var effect: PermEffectComponent = PermEffectComponent.new()
## @export var alchemy_tier: int = 1

func _init(effect_data: PermEffectComponent) -> void:
	effect = effect_data

func _apply_effect(actor: Player):
	assert(effect != null, "UpgradeItem '%s' is missing its PermEffectComponent!" % name)
	effect.apply(actor)
