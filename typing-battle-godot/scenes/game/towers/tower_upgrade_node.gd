extends Node2D
class_name TowerUpgradeNode

signal purchase_requested(slot_id: String)

@onready var area_ring: Sprite2D = %AreaRing
@onready var info_card: PanelContainer = %InfoCard
@onready var cost_label: Label = %CostLabel
@onready var stats_label: Label = %StatsLabel
@onready var purchase_button: TextureButton = %PurchaseButton
@onready var build_sfx: AudioStreamPlayer2D = %BuildSfx
@onready var upgrade_sfx: AudioStreamPlayer2D = %UpgradeSfx

var slot_id: String = ""
var _last_level: int = 0


func _ready() -> void:
	if purchase_button != null:
		if not purchase_button.pressed.is_connected(_on_purchase_pressed):
			purchase_button.pressed.connect(_on_purchase_pressed)

		if not purchase_button.mouse_entered.is_connected(_on_button_hovered):
			purchase_button.mouse_entered.connect(_on_button_hovered)

		if not purchase_button.mouse_exited.is_connected(_on_button_unhovered):
			purchase_button.mouse_exited.connect(_on_button_unhovered)

		purchase_button.scale = Vector2.ONE
		purchase_button.modulate.a = 0.82
		purchase_button.pivot_offset = purchase_button.size * 0.5

	if info_card != null:
		info_card.visible = false
		info_card.pivot_offset = info_card.size * 0.5
		_start_info_card_float()


func setup_slot(new_slot_id: String) -> void:
	slot_id = new_slot_id


func set_screen_position(screen_position: Vector2) -> void:
	global_position = screen_position


func set_info_card_visible(is_visible: bool) -> void:
	if info_card != null:
		info_card.visible = is_visible


func refresh_slot_state(slot_data: Variant, current_gold: int) -> void:
	if slot_data == null:
		_set_unavailable_state()
		return

	var data: Dictionary = slot_data as Dictionary
	var level: int = int(data.get("level", 0))
	var next_cost: int = int(data.get("next_cost", -1))
	var max_level: int = int(data.get("max_level", 0))
	var current_stats: Dictionary = data.get("current_stats", {})

	_play_purchase_sfx_if_needed(level)

	if next_cost < 0:
		if purchase_button != null:
			purchase_button.disabled = true
			purchase_button.modulate.a = 0.35

		if cost_label != null:
			cost_label.text = "Max Level"
	else:
		var can_afford: bool = current_gold >= next_cost

		if purchase_button != null:
			purchase_button.disabled = not can_afford
			purchase_button.modulate.a = 0.82 if can_afford else 0.35

		if cost_label != null:
			cost_label.text = "Cost: %d" % next_cost

	if area_ring != null:
		area_ring.visible = level <= 0

	if stats_label != null:
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

	_last_level = level


func _set_unavailable_state() -> void:
	if purchase_button != null:
		purchase_button.disabled = true
		purchase_button.modulate.a = 0.35

	if cost_label != null:
		cost_label.text = ""

	if stats_label != null:
		stats_label.text = "Unavailable"

	if area_ring != null:
		area_ring.visible = false

	if info_card != null:
		info_card.visible = false


func _on_purchase_pressed() -> void:
	if slot_id.is_empty():
		return

	purchase_requested.emit(slot_id)


func _on_button_hovered() -> void:
	if purchase_button == null:
		return

	var tween_key := "hover_tween_%s" % purchase_button.get_instance_id()
	_kill_tree_meta_tween(tween_key)

	var target_alpha := 0.35 if purchase_button.disabled else 1.0
	var target_scale := Vector2.ONE if purchase_button.disabled else Vector2(1.08, 1.08)

	var tween := create_tween()
	tween.tween_property(purchase_button, "scale", target_scale, 0.12)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(purchase_button, "modulate:a", target_alpha, 0.12)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	set_meta(tween_key, tween)

	if info_card != null:
		info_card.visible = true


func _on_button_unhovered() -> void:
	if purchase_button != null:
		var tween_key := "hover_tween_%s" % purchase_button.get_instance_id()
		_kill_tree_meta_tween(tween_key)

		var target_alpha := 0.35 if purchase_button.disabled else 0.82

		var tween := create_tween()
		tween.tween_property(purchase_button, "scale", Vector2.ONE, 0.12)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(purchase_button, "modulate:a", target_alpha, 0.12)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		set_meta(tween_key, tween)

	if info_card != null:
		info_card.visible = false


func _play_purchase_sfx_if_needed(new_level: int) -> void:
	if new_level <= _last_level:
		return

	if _last_level <= 0 and new_level >= 1:
		if build_sfx != null:
			build_sfx.play()
	else:
		if upgrade_sfx != null:
			upgrade_sfx.play()


func _start_info_card_float() -> void:
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
