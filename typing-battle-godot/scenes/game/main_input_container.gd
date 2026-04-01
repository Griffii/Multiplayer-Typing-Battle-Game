extends Control

signal word_submitted(text: String)
signal input_changed(text: String, correct_so_far: bool)

@onready var word_visual: RichTextLabel = %WordVisual
@onready var type_input: LineEdit = %TypeInput
@onready var typing_sfx_player: AudioStreamPlayer2D = %TypingSfxPlayer

var target_word: String = ""

func _ready() -> void:
	type_input.text_changed.connect(_on_text_changed)
	type_input.text_submitted.connect(_on_text_submitted)
	
	# Hide the LineEdit text itself, keep the caret/input behavior.
	type_input.add_theme_color_override("font_color", Color(1, 1, 1, 0))
	type_input.add_theme_color_override("font_placeholder_color", Color(1, 1, 1, 0))
	type_input.add_theme_color_override("font_uneditable_color", Color(1, 1, 1, 0))
	
	word_visual.text = ""


func set_target_word(word: String) -> void:
	if word == target_word:
		return
	
	target_word = word
	type_input.text = ""
	_render_hybrid_text("")


func clear_input() -> void:
	type_input.text = ""
	_render_hybrid_text("")


func set_editable(is_editable: bool) -> void:
	type_input.editable = is_editable


func grab_input_focus() -> void:
	type_input.grab_focus()


func release_input_focus() -> void:
	type_input.release_focus()


func get_input_text() -> String:
	return type_input.text


func _on_text_changed(new_text: String) -> void:
	if typing_sfx_player != null:
		typing_sfx_player.play()

	var correct_so_far: bool = _is_prefix_correct(new_text)
	_render_hybrid_text(new_text)
	input_changed.emit(new_text, correct_so_far)


func _on_text_submitted(text: String) -> void:
	word_submitted.emit(text)


func _is_prefix_correct(text: String) -> bool:
	for i: int in range(text.length()):
		if i >= target_word.length():
			return false
		if text[i] != target_word[i]:
			return false
	return true


func _render_hybrid_text(input_text: String) -> void:
	if target_word.is_empty():
		word_visual.text = ""
		return

	var bbcode: String = ""

	for i: int in range(target_word.length()):
		var target_char: String = target_word.substr(i, 1)

		if i < input_text.length():
			var typed_char: String = input_text.substr(i, 1)

			if typed_char == target_char:
				bbcode += "[color=#9CFF9C]" + _escape_bbcode(target_char) + "[/color]"
			else:
				bbcode += "[color=#FF9C9C]" + _escape_bbcode(target_char) + "[/color]"
		else:
			bbcode += "[color=#FFFFFF]" + _escape_bbcode(target_char) + "[/color]"

	word_visual.text = bbcode


func _escape_bbcode(text: String) -> String:
	return text.replace("[", "[lb]").replace("]", "[rb]")
