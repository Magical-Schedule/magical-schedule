extends Resource
class_name Crop

@export var crop_name: String = "" 
@export var growth_stages: int = 4  
@export var time_per_stage: float = 5.0 # Hitrejše za testiranje

var current_stage: int = 0  
var growth_timer: float = 0.0

@export var base_yield: int = 2
@export var harvest_item_name: String = "" # Prazno, da ga Field.gd prisili v pravilno ime



func is_mature() -> bool:
	return current_stage >= growth_stages - 1

func grow(delta: float, moisture: float = 1.0, light: float = 1.0) -> bool:
	if is_mature():
		return false

	# Okoljski vpliv na hitrost rasti
	var growth_multiplier := moisture * light
	
	growth_timer += delta * growth_multiplier
	if growth_timer >= time_per_stage:
		growth_timer = 0.0
		current_stage += 1
		return true  # Stage se je spremenil
	return false
