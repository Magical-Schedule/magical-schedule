extends Resource
class_name Crop

# Osnovno
@export var crop_name: String = "blue_plant"
@export var growth_stages: int = 4  # koliko faz rasti
@export var time_per_stage: float = 13.0  # sekunde za vsako fazo (za debug)

# Trenutno stanje
var current_stage: int = 0  # 0 = ravno posajeno, 3 = zrelo (pri 4 fazah)
var growth_timer: float = 0.0

# Yield
@export var base_yield: int = 2
@export var harvest_item_name: String = "blue_flower"

func is_mature() -> bool:
	return current_stage >= growth_stages - 1

func grow(delta: float) -> bool:
	if is_mature():
		return false
	
	growth_timer += delta
	if growth_timer >= time_per_stage:
		growth_timer = 0.0
		current_stage += 1
		return true  # Stage se je spremenil
	return false
