extends Node

signal wave_started(wave_index: int)
signal wave_cleared(wave_index: int)
signal all_waves_cleared
signal spawn_enemy_requested(enemy_data: Dictionary)

var wave_definitions: Array = []
var current_wave_index: int = -1
var current_wave_queue: Array = []
var current_spawn_cursor: int = 0

var alive_enemy_count: int = 0
var pending_spawn_count: int = 0
var wave_active: bool = false
var wave_finished: bool = false


## ENDLESS MODE WAVE GENERATION DATA AND FUNCTIONS ################################################

const ENDLESS_MAX_WAVES: int = 100

const ENEMY_GROUP_TO_TYPES := {
	"soldiers": ["grunt", "scout", "tank", "boss"],
	"slimes": ["slime", "boss_slime"],
}

const ENEMY_GENERATION_DATA := {
	"grunt": {
		"cost": 1,
		"min_wave": 1,
		"weight": 10,
		"speed_variance": 0.16,
	},
	"slime": {
		"cost": 1,
		"min_wave": 1,
		"weight": 10,
		"speed_variance": 0.18,
	},
	"scout": {
		"cost": 2,
		"min_wave": 3,
		"weight": 5,
		"speed_variance": 0.22,
	},
	"tank": {
		"cost": 4,
		"min_wave": 6,
		"weight": 3,
		"speed_variance": 0.10,
	},
	"boss": {
		"cost": 14,
		"min_wave": 10,
		"weight": 1,
		"speed_variance": 0.05,
	},
	"boss_slime": {
		"cost": 14,
		"min_wave": 10,
		"weight": 1,
		"speed_variance": 0.05,
	},
}


func build_endless_wave_definitions(config: EndlessRunConfig) -> Array:
	var generated_waves: Array = []

	for wave_number in range(1, ENDLESS_MAX_WAVES + 1):
		generated_waves.append(_build_endless_wave(config, wave_number))

	return generated_waves


func _build_endless_wave(config: EndlessRunConfig, wave_number: int) -> Dictionary:
	var budget: int = _get_endless_wave_budget(wave_number)
	var eligible_enemy_types: Array[String] = _get_eligible_enemy_types(config.enabled_enemy_groups, wave_number)
	var selected_word_lists: Array[String] = config.selected_word_list_ids.duplicate()
	var enemies: Array = []

	if eligible_enemy_types.is_empty():
		return {
			"spawn_interval": _get_endless_spawn_interval(wave_number),
			"tower_word_list_ids": selected_word_lists,
			"enemies": enemies,
		}

	# Wave 1 must be beatable with one basic magic turret.
	if wave_number == 1:
		var starter_type: String = _get_basic_enemy_type_for_config(config)
		for i in range(5):
			enemies.append(_enemy(starter_type, wave_number))
		return {
			"spawn_interval": 1.35,
			"tower_word_list_ids": selected_word_lists,
			"enemies": enemies,
		}

	var should_include_boss: bool = _should_include_boss_wave(wave_number, eligible_enemy_types)

	if should_include_boss:
		var boss_type: String = _pick_boss_type(eligible_enemy_types)
		if not boss_type.is_empty():
			enemies.append(_enemy(boss_type, wave_number))
			budget -= int(ENEMY_GENERATION_DATA[boss_type].get("cost", 14))

			# Boss waves must still include weaker enemies.
			var support_count: int = clampi(5 + int(wave_number / 3), 6, 22)
			for i in range(support_count):
				var support_type: String = _pick_basic_or_mid_enemy_type(eligible_enemy_types)
				if not support_type.is_empty():
					enemies.append(_enemy(support_type, wave_number))
					budget -= int(ENEMY_GENERATION_DATA[support_type].get("cost", 1))

	while budget > 0:
		var enemy_type: String = _pick_enemy_type_for_horde(eligible_enemy_types, budget, wave_number)

		if enemy_type.is_empty():
			break

		var enemy_cost: int = int(ENEMY_GENERATION_DATA[enemy_type].get("cost", 1))

		if enemy_cost > budget:
			break

		enemies.append(_enemy(enemy_type, wave_number))
		budget -= enemy_cost

	# Horde feel: shuffle so tanks/bosses are not always at the end.
	enemies.shuffle()

	return {
		"spawn_interval": _get_endless_spawn_interval(wave_number),
		"tower_word_list_ids": selected_word_lists,
		"enemies": enemies,
	}


func _enemy(enemy_type: String, wave_number: int) -> Dictionary:
	return {
		"enemy_type": enemy_type,
		"speed_multiplier": _get_enemy_speed_multiplier(enemy_type, wave_number),
	}


func _get_endless_wave_budget(wave_number: int) -> int:
	# More units, less reliance on elite spam.
	var base_budget: int = 5
	var linear_growth: int = int(floor(float(wave_number) * 1.65))
	var milestone_bonus: int = int(floor(float(wave_number) / 10.0)) * 6

	return base_budget + linear_growth + milestone_bonus


func _get_endless_spawn_interval(wave_number: int) -> float:
	# Slightly faster horde pressure over time.
	var interval: float = 1.35 - (float(wave_number) * 0.01)
	return clampf(interval, 0.32, 1.35)


func _get_eligible_enemy_types(enabled_groups: Array[String], wave_number: int) -> Array[String]:
	var eligible: Array[String] = []

	for group_id in enabled_groups:
		var enemy_types: Array = ENEMY_GROUP_TO_TYPES.get(group_id, [])

		for enemy_type in enemy_types:
			if not ENEMY_GENERATION_DATA.has(enemy_type):
				continue

			var min_wave: int = int(ENEMY_GENERATION_DATA[enemy_type].get("min_wave", 1))

			if wave_number >= min_wave and not eligible.has(enemy_type):
				eligible.append(enemy_type)

	return eligible


func _pick_enemy_type_for_horde(eligible_enemy_types: Array[String], remaining_budget: int, wave_number: int) -> String:
	var weighted_pool: Array[String] = []

	for enemy_type in eligible_enemy_types:
		var data: Dictionary = ENEMY_GENERATION_DATA[enemy_type]
		var enemy_cost: int = int(data.get("cost", 1))

		if enemy_cost > remaining_budget:
			continue

		if _is_boss_type(enemy_type):
			# Bosses are handled intentionally, not randomly spammed.
			continue

		var weight: int = int(data.get("weight", 1))

		# Later waves allow more tanks/scouts, but still mostly horde units.
		if enemy_type == "tank":
			weight += int(wave_number / 8)
		elif enemy_type == "scout":
			weight += int(wave_number / 6)
		else:
			weight += int(wave_number / 10)

		for i in range(max(1, weight)):
			weighted_pool.append(enemy_type)

	if weighted_pool.is_empty():
		return _pick_affordable_non_boss_enemy(eligible_enemy_types, remaining_budget)

	return weighted_pool[randi() % weighted_pool.size()]


func _pick_affordable_non_boss_enemy(eligible_enemy_types: Array[String], remaining_budget: int) -> String:
	var affordable: Array[String] = []

	for enemy_type in eligible_enemy_types:
		if _is_boss_type(enemy_type):
			continue

		var enemy_cost: int = int(ENEMY_GENERATION_DATA[enemy_type].get("cost", 1))

		if enemy_cost <= remaining_budget:
			affordable.append(enemy_type)

	if affordable.is_empty():
		return ""

	return affordable[randi() % affordable.size()]


func _should_include_boss_wave(wave_number: int, eligible_enemy_types: Array[String]) -> bool:
	if wave_number < 10:
		return false

	if _pick_boss_type(eligible_enemy_types).is_empty():
		return false

	# Boss every 10 waves, then occasional later boss pressure.
	if wave_number % 10 == 0:
		return true

	if wave_number >= 25 and wave_number % 15 == 0:
		return true

	return false


func _pick_boss_type(eligible_enemy_types: Array[String]) -> String:
	var bosses: Array[String] = []

	for enemy_type in eligible_enemy_types:
		if _is_boss_type(enemy_type):
			bosses.append(enemy_type)

	if bosses.is_empty():
		return ""

	return bosses[randi() % bosses.size()]


func _pick_basic_or_mid_enemy_type(eligible_enemy_types: Array[String]) -> String:
	var preferred: Array[String] = []

	for enemy_type in eligible_enemy_types:
		if _is_boss_type(enemy_type):
			continue

		if enemy_type == "grunt" or enemy_type == "slime" or enemy_type == "scout":
			preferred.append(enemy_type)

	if preferred.is_empty():
		return _pick_affordable_non_boss_enemy(eligible_enemy_types, 999)

	return preferred[randi() % preferred.size()]


func _get_basic_enemy_type_for_config(config: EndlessRunConfig) -> String:
	if config.enabled_enemy_groups.has("soldiers"):
		return "grunt"

	if config.enabled_enemy_groups.has("slimes"):
		return "slime"

	return "grunt"


func _get_enemy_speed_multiplier(enemy_type: String, wave_number: int) -> float:
	var variance: float = float(ENEMY_GENERATION_DATA.get(enemy_type, {}).get("speed_variance", 0.12))
	var low: float = 1.0 - variance
	var high: float = 1.0 + variance

	# Later waves get tiny global speed pressure, capped low.
	var wave_bonus: float = min(0.18, float(wave_number - 1) * 0.004)

	return randf_range(low, high) + wave_bonus


func _is_boss_type(enemy_type: String) -> bool:
	return enemy_type == "boss" or enemy_type == "boss_slime"


###################################################################################################


func set_wave_definitions(waves: Array) -> void:
	wave_definitions = waves.duplicate(true)


func reset_for_new_run() -> void:
	current_wave_index = -1
	current_wave_queue.clear()
	current_spawn_cursor = 0
	alive_enemy_count = 0
	pending_spawn_count = 0
	wave_active = false
	wave_finished = false


func start_wave(wave_index: int) -> void:
	if wave_index < 0:
		return

	if wave_index >= wave_definitions.size():
		all_waves_cleared.emit()
		return

	current_wave_index = wave_index
	current_wave_queue.clear()
	current_spawn_cursor = 0
	alive_enemy_count = 0
	pending_spawn_count = 0
	wave_finished = false
	wave_active = true

	var wave_data_variant: Variant = wave_definitions[wave_index]
	if typeof(wave_data_variant) != TYPE_DICTIONARY:
		push_warning("WaveManager: wave %d is not a Dictionary." % wave_index)
		current_wave_queue.clear()
		pending_spawn_count = 0
		_try_finish_wave()
		return

	var wave_data: Dictionary = wave_data_variant as Dictionary
	var enemies_variant: Variant = wave_data.get("enemies", [])

	if typeof(enemies_variant) == TYPE_ARRAY:
		current_wave_queue = (enemies_variant as Array).duplicate(true)
	else:
		current_wave_queue = []

	pending_spawn_count = current_wave_queue.size()

	wave_started.emit(current_wave_index)

	if pending_spawn_count == 0:
		_try_finish_wave()


func get_current_wave_data() -> Dictionary:
	if current_wave_index < 0 or current_wave_index >= wave_definitions.size():
		return {}

	var wave_data_variant: Variant = wave_definitions[current_wave_index]
	if typeof(wave_data_variant) != TYPE_DICTIONARY:
		return {}

	return wave_data_variant as Dictionary


func has_more_enemies_to_spawn() -> bool:
	return current_spawn_cursor < current_wave_queue.size()


func get_next_enemy_data() -> Dictionary:
	if not has_more_enemies_to_spawn():
		return {}

	var enemy_variant: Variant = current_wave_queue[current_spawn_cursor]
	current_spawn_cursor += 1

	if typeof(enemy_variant) != TYPE_DICTIONARY:
		push_warning("WaveManager: enemy entry %d in wave %d is not a Dictionary." % [current_spawn_cursor - 1, current_wave_index])
		pending_spawn_count = max(0, pending_spawn_count - 1)
		_try_finish_wave()
		return {}

	return enemy_variant as Dictionary


func request_next_enemy_spawn() -> void:
	if not wave_active:
		return

	var enemy_data: Dictionary = get_next_enemy_data()
	if enemy_data.is_empty():
		return

	spawn_enemy_requested.emit(enemy_data)


func notify_enemy_spawned(_enemy: Node) -> void:
	if not wave_active:
		return

	alive_enemy_count += 1
	pending_spawn_count = max(0, pending_spawn_count - 1)


func notify_enemy_died(_enemy: Node) -> void:
	if alive_enemy_count > 0:
		alive_enemy_count -= 1

	_try_finish_wave()


func notify_spawn_queue_exhausted() -> void:
	_try_finish_wave()


func is_wave_active() -> bool:
	return wave_active


func get_alive_enemy_count() -> int:
	return alive_enemy_count


func get_pending_spawn_count() -> int:
	return pending_spawn_count


func get_unspawned_enemies() -> Array:
	var remaining: Array = []

	if current_spawn_cursor >= current_wave_queue.size():
		return remaining

	for i in range(current_spawn_cursor, current_wave_queue.size()):
		var enemy_data: Variant = current_wave_queue[i]
		if typeof(enemy_data) == TYPE_DICTIONARY:
			remaining.append((enemy_data as Dictionary).duplicate(true))

	return remaining


func debug_skip_current_wave() -> Array:
	if not wave_active:
		return []

	var unspawned_enemies: Array = get_unspawned_enemies()

	current_spawn_cursor = current_wave_queue.size()
	pending_spawn_count = 0
	alive_enemy_count = 0

	_try_finish_wave()

	return unspawned_enemies


func _try_finish_wave() -> void:
	if not wave_active:
		return

	if has_more_enemies_to_spawn():
		return

	if pending_spawn_count > 0:
		return

	if alive_enemy_count > 0:
		return

	if wave_finished:
		return

	wave_finished = true
	wave_active = false

	if current_wave_index >= wave_definitions.size() - 1:
		all_waves_cleared.emit()
	else:
		wave_cleared.emit(current_wave_index)
