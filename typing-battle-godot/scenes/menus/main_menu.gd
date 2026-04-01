extends Control

signal solo_requested
signal create_requested
signal join_requested

@onready var solo_button: Button = %SoloButton
@onready var create_button: Button = %CreateButton
@onready var join_button: Button = %JoinButton
@onready var title_label: RichTextLabel = %TitleLabel

func _ready() -> void:
	solo_button.pressed.connect(_on_solo_pressed)
	create_button.pressed.connect(_on_create_pressed)
	join_button.pressed.connect(_on_join_pressed)

	solo_button.disabled = true

	title_label.bbcode_enabled = true
	title_label.scroll_active = false
	title_label.fit_content = true

	var wave_effect := WaveTextEffect.new()
	title_label.install_effect(wave_effect)
	
	title_label.text = "[center][wave height=8 speed=2.2 spacing=0.45]Super Fun & Cool Typing Battle Game![/wave][/center]"


func _on_solo_pressed() -> void:
	solo_requested.emit()


func _on_create_pressed() -> void:
	create_requested.emit()


func _on_join_pressed() -> void:
	join_requested.emit()
