extends Control

signal selection_finished
signal back_requested

const GRASSLANDS_SCENE: PackedScene = preload("res://scenes/game/levels/grasslands.tscn")
const SEASIDE_FARM_SCENE: PackedScene = preload("res://scenes/game/levels/seaside_farm.tscn")
const WAVE_SET_01 = preload("res://data/waves/wave_set_01.gd")
const WAVE_SET_SLIME_01 = preload("res://data/waves/wave_set_slime_01.gd")

@onready var grasslands_button: Button = %GrasslandsButton
@onready var seaside_farm_button: Button = %SeasideFarmButton
@onready var wave_set_01_button: Button = %SoldiersButton
@onready var slime_wave_button: Button = %SlimesButton
@onready var back_button: Button = %BackButton
@onready var finish_button: Button = %FinishButton


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	if grasslands_button != null and not grasslands_button.pressed.is_connected(_on_grasslands_pressed):
		grasslands_button.pressed.connect(_on_grasslands_pressed)

	if seaside_farm_button != null and not seaside_farm_button.pressed.is_connected(_on_seasidefarm_pressed):
		seaside_farm_button.pressed.connect(_on_seasidefarm_pressed)

	if wave_set_01_button != null and not wave_set_01_button.pressed.is_connected(_on_wave_set_01_pressed):
		wave_set_01_button.pressed.connect(_on_wave_set_01_pressed)

	if slime_wave_button != null and not slime_wave_button.pressed.is_connected(_on_slime_wave_pressed):
		slime_wave_button.pressed.connect(_on_slime_wave_pressed)

	if back_button != null and not back_button.pressed.is_connected(_on_back_pressed):
		back_button.pressed.connect(_on_back_pressed)

	if finish_button != null and not finish_button.pressed.is_connected(_on_finish_pressed):
		finish_button.pressed.connect(_on_finish_pressed)


func _on_grasslands_pressed() -> void:
	GameSelection.set_level_scene(GRASSLANDS_SCENE)


func _on_seasidefarm_pressed() -> void:
	GameSelection.set_level_scene(SEASIDE_FARM_SCENE)


func _on_wave_set_01_pressed() -> void:
	GameSelection.set_wave_set_script(WAVE_SET_01)


func _on_slime_wave_pressed() -> void:
	GameSelection.set_wave_set_script(WAVE_SET_SLIME_01)


func _on_back_pressed() -> void:
	back_requested.emit()


func _on_finish_pressed() -> void:
	selection_finished.emit()
