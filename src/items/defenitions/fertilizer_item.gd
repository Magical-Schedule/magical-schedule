## Base class for all fertilizers.
extends Node
class_name FertilizerItem

func _apply_effect(actor: Player):
	var target = actor.interaction_raycast.get_collider()
	# if target is Plant:
	# 	target.apply_growth_boost(stat_modifiers)
