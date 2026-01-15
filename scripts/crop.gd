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

# Stres rastline (0 = brez stresa, 1 = max stres)
var stress: float = 0.0
const STRESS_INCREASE_RATE := 0.15
const STRESS_RECOVERY_RATE := 0.1

func is_mature() -> bool:
	return current_stage >= growth_stages - 1

func grow(delta: float, moisture: float = 1.0, light: float = 1.0) -> bool:
	if is_mature():
		return false

	# Okoljski multiplikator
	var growth_multiplier := moisture * light

	# Stres raste, če so pogoji slabi
	if moisture < 0.3 or light < 0.3:
		stress = min(1.0, stress + STRESS_INCREASE_RATE * delta)
	else:
		stress = max(0.0, stress - STRESS_RECOVERY_RATE * delta)

	# Stres upočasni rast
	growth_multiplier *= (1.0 - stress)

	growth_timer += delta * growth_multiplier
	if growth_timer >= time_per_stage:
		growth_timer = 0.0
		current_stage += 1
		return true

	return false
