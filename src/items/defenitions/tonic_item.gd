## Base class for all tonics.
extends Item
class_name TonicItem

@export var effect: TempEffectComponent = TempEffectComponent.new()
## @export var alchemy_tier: int = 1

func _init(effect_data: TempEffectComponent) -> void:
	effect = effect_data

func _apply_effect(actor: Player):
	assert(effect != null, "TonicItem '%s' is missing its TempEffectComponent!" % name)
	effect.apply(actor)
