extends CanvasLayer

signal return_to_shop_requested
signal tower_purchase_requested(slot_id: String)

@onready var gold_label: Label = %GoldLabel
@onready var return_button: Button = %ReturnToShopButton

@onready var slot_01_area_ring: Sprite2D = %Slot01AreaRing
@onready var slot_01_info_card: PanelContainer = %Slot01InfoCard
@onready var slot_01_cost: Label = %Slot01Cost
@onready var slot_01_stats: Label = %Slot01Stats
@onready var slot_01_button: TextureButton = %Slot01Button

@onready var slot_02_area_ring: Sprite2D = %Slot02AreaRing
@onready var slot_02_info_card: PanelContainer = %Slot02InfoCard
@onready var slot_02_cost: Label = %Slot02Cost
@onready var slot_02_stats: Label = %Slot02Stats
@onready var slot_02_button: TextureButton = %Slot02Button

@onready var slot_03_area_ring: Sprite2D = %Slot03AreaRing
@onready var slot_03_info_card: PanelContainer = %Slot03InfoCard
@onready var slot_03_cost: Label = %Slot03Cost
@onready var slot_03_stats: Label = %Slot03Stats
@onready var slot_03_button: TextureButton = %Slot03Button

@onready var build_sfx: AudioStreamPlayer2D = %"build-sfx"
@onready var upgrade_sfx: AudioStreamPlayer2D = %"upgrade-sfx"

var _last_levels: Dictionary = {}
var _slot_nodes := {}
var _current_gold: int = 0


func _ready() -> void:
	visible = false

	_slot_nodes = {
		"slot_01": {
			"area_ring": slot_01_area_ring,
			"info_card": slot_01_info_card,
			"cost_label": slot_01_cost,
			"stats_label": slot_01_stats,
			"button": slot_01_button
		},
		"slot_02": {
			"area_ring": slot_02_area_ring,
			"info_card": slot_02_info_card,
			"cost_label": slot_02_cost,
			"stats_label": slot_02_stats,
			"button": slot_02_button
		},
		"slot_03": {
			"area_ring": slot_03_area_ring,
			"info_card": slot_03_info_card,
			"cost_label": slot_03_cost,
			"stats_label": slot_03_stats,
			"button": slot_03_button
		}
	}

	return_button.pressed.connect(_on_return_pressed)

	_connect_slot_button(slot_01_button, "slot_01")
	_connect_slot_button(slot_02_button, "slot_02")
	_connect_slot_button(slot_03_button, "slot_03")

	_setup_slot_visuals("slot_01")
	_setup_slot_visuals("slot_02")
	_setup_slot_visuals("slot_03")


func show_overlay(build_state: Dictionary) -> void:
	visible = true
	refresh_build(build_state)
	_resume_slot_animations()


func hide_overlay() -> void:
	visible = false


func refresh_build(build_state: Dictionary) -> void:
	_current_gold = int(build_state.get("gold", 0))
	gold_label.text = "%d" % _current_gold

	var slots: Dictionary = build_state.get("slots", {})

	_refresh_slot_ui("slot_01", slots)
	_refresh_slot_ui("slot_02", slots)
	_refresh_slot_ui("slot_03", slots)


func _refresh_slot_ui(slot_id: String, slots: Dictionary) -> void:
	var slot_ui: Dictionary = _slot_nodes.get(slot_id, {})
	if slot_ui.is_empty():
		return

	var button: TextureButton = slot_ui["button"]
	var cost_label: Label = slot_ui["cost_label"]
	var stats_label: Label = slot_ui["stats_label"]
	var area_ring: Sprite2D = slot_ui["area_ring"]
	var info_card: PanelContainer = slot_ui["info_card"]

	if not slots.has(slot_id):
		button.disabled = true
		button.modulate.a = 0.35
		cost_label.text = ""
		stats_label.text = "Unavailable"

		if area_ring != null:
			area_ring.visible = false

		if info_card != null:
			info_card.visible = false

		return

	var slot_data: Dictionary = slots[slot_id]
	var level: int = int(slot_data.get("level", 0))
	var next_cost: int = int(slot_data.get("next_cost", -1))
	var max_level: int = int(slot_data.get("max_level", 0))
	var current_stats: Dictionary = slot_data.get("current_stats", {})

	_play_slot_purchase_sfx_if_needed(slot_id, level)

	if next_cost < 0:
		button.disabled = true
		cost_label.text = "Max Level"
	else:
		button.disabled = _current_gold < next_cost
		cost_label.text = "Cost: %d" % next_cost

	button.modulate.a = 0.35 if button.disabled else 0.82

	if area_ring != null:
		area_ring.visible = level <= 0

	if level <= 0:
		stats_label.text = ""
	else:
		var damage: int = int(current_stats.get("damage", 0))
		var charge_required: int = int(current_stats.get("charge_required", 0))
		var duration: float = float(current_stats.get("duration", 0.0))
		var cooldown: float = float(current_stats.get("cooldown", 0.0))
		var attack_interval: float = float(current_stats.get("attack_interval", 0.0))
		var range: float = float(current_stats.get("range", 0.0))

		stats_label.text = (
			"LV %d / %d\n"
			+ "DMG: %d\n"
			+ "Charge: %d\n"
			+ "Duration: %.1fs\n"
			+ "Cooldown: %.1fs\n"
			+ "Rate: %.2fs\n"
			+ "Range: %d"
		) % [
			level,
			max_level,
			damage,
			charge_required,
			duration,
			cooldown,
			attack_interval,
			int(range)
		]

	if info_card != null:
		info_card.visible = false

	_last_levels[slot_id] = level


func _connect_slot_button(button: TextureButton, slot_id: String) -> void:
	button.pressed.connect(func(): tower_purchase_requested.emit(slot_id))
	button.mouse_entered.connect(func(): _on_slot_button_hovered(slot_id))
	button.mouse_exited.connect(func(): _on_slot_button_unhovered(slot_id))


func _setup_slot_visuals(slot_id: String) -> void:
	var slot_ui: Dictionary = _slot_nodes.get(slot_id, {})
	if slot_ui.is_empty():
		return

	var button: TextureButton = slot_ui["button"]
	var info_card: Control = slot_ui["info_card"]

	if button != null:
		button.scale = Vector2.ONE
		button.modulate.a = 0.82
		button.pivot_offset = button.size * 0.5

	if info_card != null:
		info_card.visible = false
		info_card.pivot_offset = info_card.size * 0.5
		_start_info_card_float(info_card)


func _resume_slot_animations() -> void:
	for slot_id in _slot_nodes.keys():
		var slot_ui: Dictionary = _slot_nodes[slot_id]
		var info_card: Control = slot_ui["info_card"]

		if info_card != null and not _has_meta_tween(info_card, "float_tween"):
			_start_info_card_float(info_card)


func _start_info_card_float(info_card: Control) -> void:
	if info_card == null:
		return

	_kill_meta_tween(info_card, "float_tween")

	var base_pos: Vector2 = info_card.position
	info_card.set_meta("base_pos", base_pos)
	info_card.rotation_degrees = 0.0

	var tween := create_tween()
	tween.set_loops()
	tween.tween_property(info_card, "position", base_pos + Vector2(0, -4), 1.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(info_card, "rotation_degrees", 1.2, 1.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(info_card, "position", base_pos + Vector2(0, 3), 1.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(info_card, "rotation_degrees", -1.0, 1.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(info_card, "position", base_pos, 1.1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(info_card, "rotation_degrees", 0.4, 1.1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(info_card, "rotation_degrees", 0.0, 0.8)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	info_card.set_meta("float_tween", tween)


func _on_slot_button_hovered(slot_id: String) -> void:
	var slot_ui: Dictionary = _slot_nodes.get(slot_id, {})
	if slot_ui.is_empty():
		return

	var button: TextureButton = slot_ui["button"]
	var info_card: Control = slot_ui["info_card"]

	if button == null:
		return

	var tween_key := "hover_tween_%s" % button.get_instance_id()
	_kill_tree_meta_tween(tween_key)

	var target_alpha := 0.35 if button.disabled else 1.0
	var target_scale := Vector2.ONE if button.disabled else Vector2(1.08, 1.08)

	var tween := create_tween()
	tween.tween_property(button, "scale", target_scale, 0.12)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(button, "modulate:a", target_alpha, 0.12)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	set_meta(tween_key, tween)

	if info_card != null:
		info_card.visible = true


func _on_slot_button_unhovered(slot_id: String) -> void:
	var slot_ui: Dictionary = _slot_nodes.get(slot_id, {})
	if slot_ui.is_empty():
		return

	var button: TextureButton = slot_ui["button"]
	var info_card: Control = slot_ui["info_card"]

	if button != null:
		var tween_key := "hover_tween_%s" % button.get_instance_id()
		_kill_tree_meta_tween(tween_key)

		var target_alpha := 0.35 if button.disabled else 0.82

		var tween := create_tween()
		tween.tween_property(button, "scale", Vector2.ONE, 0.12)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(button, "modulate:a", target_alpha, 0.12)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		set_meta(tween_key, tween)

	if info_card != null:
		info_card.visible = false


func _play_slot_purchase_sfx_if_needed(slot_id: String, new_level: int) -> void:
	var previous_level: int = int(_last_levels.get(slot_id, 0))

	if new_level <= previous_level:
		return

	if previous_level <= 0 and new_level >= 1:
		if build_sfx != null:
			build_sfx.play()
	else:
		if upgrade_sfx != null:
			upgrade_sfx.play()


func _has_meta_tween(node: Node, key: String) -> bool:
	if node == null:
		return false
	if not node.has_meta(key):
		return false

	var tween = node.get_meta(key)
	return tween != null and is_instance_valid(tween)


func _kill_meta_tween(node: Node, key: String) -> void:
	if node == null or not node.has_meta(key):
		return

	var tween = node.get_meta(key)
	if tween != null and is_instance_valid(tween):
		tween.kill()

	node.remove_meta(key)


func _kill_tree_meta_tween(key: String) -> void:
	if not has_meta(key):
		return

	var tween = get_meta(key)
	if tween != null and is_instance_valid(tween):
		tween.kill()

	remove_meta(key)


func _on_return_pressed() -> void:
	return_to_shop_requested.emit()
