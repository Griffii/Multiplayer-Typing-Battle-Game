extends CanvasLayer

signal back_to_menu_requested
signal play_again_requested
signal return_to_map_requested

const BUTTON_BASE_SCALE: Vector2 = Vector2.ONE
const BUTTON_HOVER_SCALE: Vector2 = Vector2(1.08, 1.08)
const BUTTON_HOVER_TIME: float = 0.08

@onready var title_label: Label = %TitleLabel
@onready var result_label: Label = %ResultLabel
@onready var summary_label: Label = %SummaryLabel

@onready var back_to_menu_button: Button = %BackToMenuButton
@onready var play_again_button: Button = %PlayAgainButton
@onready var to_map_button: Button = %ToMapButton

@onready var fanfare_sfx: AudioStreamPlayer = %FanfareSfx
@onready var fail_sfx: AudioStreamPlayer = %FailSfx

var button_tweens: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	_connect_button(back_to_menu_button, _on_back_to_menu_pressed)
	_connect_button(play_again_button, _on_play_again_pressed)
	_connect_button(to_map_button, _on_return_to_map_pressed)

	_setup_hover_button(back_to_menu_button)
	_setup_hover_button(play_again_button)
	_setup_hover_button(to_map_button)

	title_label.text = "Game Over"
	result_label.text = ""
	summary_label.text = ""

	play_again_button.visible = true
	play_again_button.disabled = false

	to_map_button.visible = false
	to_map_button.disabled = true

	visible = false


func _connect_button(button: Button, callback: Callable) -> void:
	if button == null:
		return

	if not button.pressed.is_connected(callback):
		button.pressed.connect(callback)


func _setup_hover_button(button: Button) -> void:
	if button == null:
		return

	button.pivot_offset = button.size * 0.5

	if not button.mouse_entered.is_connected(_on_button_mouse_entered.bind(button)):
		button.mouse_entered.connect(_on_button_mouse_entered.bind(button))

	if not button.mouse_exited.is_connected(_on_button_mouse_exited.bind(button)):
		button.mouse_exited.connect(_on_button_mouse_exited.bind(button))


func _on_button_mouse_entered(button: Button) -> void:
	_tween_button_scale(button, BUTTON_HOVER_SCALE)


func _on_button_mouse_exited(button: Button) -> void:
	_tween_button_scale(button, BUTTON_BASE_SCALE)


func _tween_button_scale(button: Button, target_scale: Vector2) -> void:
	if button == null:
		return

	if button_tweens.has(button):
		var old_tween: Tween = button_tweens[button] as Tween
		if old_tween != null and old_tween.is_valid():
			old_tween.kill()

	var tween: Tween = create_tween()
	tween.tween_property(button, "scale", target_scale, BUTTON_HOVER_TIME)
	button_tweens[button] = tween


func show_results(data: Dictionary) -> void:
	visible = true

	var did_win: bool = bool(data.get("did_win", false))
	var wave_reached: int = int(data.get("wave_reached", 0))
	var total_waves: int = int(data.get("total_waves", 0))
	var mode: String = String(data.get("mode", "endless"))
	var is_campaign: bool = mode == "campaign"

	if did_win:
		result_label.text = "Victory!"
		if fanfare_sfx != null:
			fanfare_sfx.play()
	else:
		result_label.text = "Defeat"
		if fail_sfx != null:
			fail_sfx.play()

	summary_label.text = "Wave Reached: %d / %d" % [wave_reached, total_waves]

	play_again_button.visible = not is_campaign
	play_again_button.disabled = is_campaign

	to_map_button.visible = is_campaign
	to_map_button.disabled = not is_campaign
	to_map_button.text = "Return to\nWorld Map"


func hide_overlay() -> void:
	visible = false

	play_again_button.visible = true
	play_again_button.disabled = false
	play_again_button.scale = BUTTON_BASE_SCALE

	to_map_button.visible = false
	to_map_button.disabled = true
	to_map_button.scale = BUTTON_BASE_SCALE

	back_to_menu_button.scale = BUTTON_BASE_SCALE

	result_label.text = ""
	summary_label.text = ""


func _on_back_to_menu_pressed() -> void:
	back_to_menu_requested.emit()


func _on_play_again_pressed() -> void:
	play_again_requested.emit()


func _on_return_to_map_pressed() -> void:
	return_to_map_requested.emit()
