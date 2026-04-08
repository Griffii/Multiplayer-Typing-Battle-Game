extends Control

signal play_requested
signal settings_requested

const LIGHTNING_SCENE: PackedScene = preload("res://scenes/game/projectiles/lightning_projectile.tscn")

const TITLE_TEXT := "Typing\nTower Defence!"
const TITLE_WAVE_OPEN := "[center][wave height=8 speed=2.2 spacing=0.45]"
const TITLE_WAVE_CLOSE := "[/wave][/center]"
const TITLE_BASE_COLOR := "#ffffff"
const TITLE_TYPED_COLOR := "#7fd6ff"

@onready var play_button: Button = %PlayButton
@onready var multiplayer_button: Button = %MultiplayerButton
@onready var settings_button: Button = %SettingsButton
@onready var title_label: RichTextLabel = %TitleLabel
@onready var tower_container: Node2D = %TowerContainer
@onready var lightning_marker: Marker2D = %LightningMarker
@onready var animation_player: AnimationPlayer = %TowerAnimPlayer
@onready var typing_sfx_player: AudioStreamPlayer2D = %TypingSfxPlayer

var rng := RandomNumberGenerator.new()
var is_shoot_animation_playing := false


func _ready() -> void:
	rng.randomize()

	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)

	multiplayer_button.disabled = true
	multiplayer_button.focus_mode = Control.FOCUS_NONE

	title_label.bbcode_enabled = true
	title_label.scroll_active = false
	title_label.fit_content = true

	var wave_effect := WaveTextEffect.new()
	title_label.install_effect(wave_effect)

	_set_title_progress(0)

	call_deferred("_run_title_cycle")


func _run_title_cycle() -> void:
	while is_inside_tree():
		_set_title_progress(0)

		await get_tree().create_timer(rng.randf_range(0.5, 1.2)).timeout

		for i in range(1, TITLE_TEXT.length() + 1):
			_set_title_progress(i)
			_play_typing_sfx()

			var delay := rng.randf_range(0.04, 0.10)

			if rng.randf() < 0.18:
				delay += rng.randf_range(0.04, 0.12)

			await get_tree().create_timer(delay).timeout

		await get_tree().create_timer(rng.randf_range(0.15, 0.35)).timeout
		await _play_random_shoot_animation()
		await get_tree().create_timer(rng.randf_range(0.6, 1.2)).timeout


func _set_title_progress(colored_count: int) -> void:
	var bbcode_text := TITLE_WAVE_OPEN

	for i in range(TITLE_TEXT.length()):
		var character := TITLE_TEXT[i]

		if character == "\n":
			bbcode_text += "\n"
			continue

		var color := TITLE_BASE_COLOR
		if i < colored_count:
			color = TITLE_TYPED_COLOR

		bbcode_text += "[color=%s]%s[/color]" % [color, _escape_bbcode_character(character)]

	bbcode_text += TITLE_WAVE_CLOSE
	title_label.text = bbcode_text


func _escape_bbcode_character(character: String) -> String:
	match character:
		"[":
			return "[lb]"
		"]":
			return "[rb]"
		_:
			return character


func _play_typing_sfx() -> void:
	if typing_sfx_player == null:
		return

	typing_sfx_player.pitch_scale = rng.randf_range(0.96, 1.04)
	typing_sfx_player.play()


func _play_random_shoot_animation() -> void:
	if animation_player == null or is_shoot_animation_playing:
		return

	is_shoot_animation_playing = true

	if rng.randi_range(0, 1) == 0:
		animation_player.play("shoot_blue")
	else:
		animation_player.play("shoot_yellow")

	await animation_player.animation_finished
	is_shoot_animation_playing = false


func spawn_lightning() -> void:
	if LIGHTNING_SCENE == null or lightning_marker == null or tower_container == null:
		return

	var lightning_instance := LIGHTNING_SCENE.instantiate()
	tower_container.add_child(lightning_instance)

	var spawn_pos := tower_container.to_local(lightning_marker.global_position)

	if lightning_instance.has_method("fire"):
		lightning_instance.fire(spawn_pos)
	elif lightning_instance is Node2D:
		lightning_instance.position = spawn_pos


func _on_play_pressed() -> void:
	play_requested.emit()


func _on_settings_pressed() -> void:
	settings_requested.emit()
