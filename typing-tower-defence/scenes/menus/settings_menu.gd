extends CanvasLayer

signal close_requested

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var close_button: Button = %BackButton

var is_closing: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	if close_button != null and not close_button.pressed.is_connected(_on_close_button_pressed):
		close_button.pressed.connect(_on_close_button_pressed)

	play_open_animation()


func play_open_animation() -> void:
	if animation_player == null:
		return

	if animation_player.has_animation("open_menu"):
		animation_player.play("open_menu")


func request_close() -> void:
	if is_closing:
		return

	is_closing = true

	if animation_player != null and animation_player.has_animation("close_menu"):
		animation_player.play("close_menu")
		await animation_player.animation_finished

	close_requested.emit()


func _on_close_button_pressed() -> void:
	request_close()
