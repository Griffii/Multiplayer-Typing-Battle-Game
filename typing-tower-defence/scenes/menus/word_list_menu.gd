extends Control

@export var columns: int = 3
@export var button_size: Vector2 = Vector2(220, 100)

@onready var margin_container: MarginContainer = %MarginContainer
@onready var vbox_container: VBoxContainer = %VBoxContainer
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var grid_container: GridContainer = %GridContainer

var _selected_list_id: String = ""


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	offset_left = 0
	offset_top = 0
	offset_right = 0
	offset_bottom = 0

	_force_layout_sizes()
	_rebuild_list_grid()

	await get_tree().process_frame
	_print_layout_debug()


func _force_layout_sizes() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL

	if margin_container != null:
		margin_container.set_anchors_preset(Control.PRESET_FULL_RECT)
		margin_container.offset_left = 20
		margin_container.offset_top = 20
		margin_container.offset_right = -20
		margin_container.offset_bottom = -20
		margin_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		margin_container.size_flags_vertical = Control.SIZE_EXPAND_FILL

	if vbox_container != null:
		vbox_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox_container.size_flags_vertical = Control.SIZE_EXPAND_FILL

	if scroll_container != null:
		scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		scroll_container.custom_minimum_size = Vector2(600, 400)

	if grid_container != null:
		grid_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		grid_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		grid_container.columns = columns
		grid_container.custom_minimum_size = Vector2(600, 400)
		grid_container.visible = true
		grid_container.modulate = Color(1, 1, 1, 1)


func _rebuild_list_grid() -> void:
	_clear_grid()

	var lists: Array[WordListData] = WordLists.get_all_lists()

	for list_data in lists:
		var button := Button.new()
		button.text = "%s\n(%d words)" % [list_data.display_name, list_data.words.size()]
		button.custom_minimum_size = button_size
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

		# Force strong visible styling for debugging
		button.modulate = Color(1, 1, 1, 1)
		button.self_modulate = Color(1, 1, 1, 1)
		button.add_theme_color_override("font_color", Color.BLACK)
		button.add_theme_color_override("font_hover_color", Color.BLACK)
		button.add_theme_color_override("font_pressed_color", Color.BLACK)
		button.add_theme_color_override("font_focus_color", Color.BLACK)

		button.set_meta("list_id", list_data.id)
		button.pressed.connect(_on_list_button_pressed.bind(list_data.id))

		grid_container.add_child(button)

	# Force container relayout after adding children
	grid_container.queue_sort()


func _clear_grid() -> void:
	for child in grid_container.get_children():
		child.queue_free()


func _on_list_button_pressed(list_id: String) -> void:
	_selected_list_id = list_id

	var list_data: WordListData = WordLists.get_list(list_id)
	if list_data == null:
		push_warning("WordListMenu: selected list '%s' was not found." % list_id)
		return

	print("Selected word list: ", list_data.display_name)
	print("ID: ", list_data.id)
	print("Words: ", list_data.words)


func _print_layout_debug() -> void:
	print("--- WORD LIST MENU DEBUG ---")
	print("Root size: ", size)
	if margin_container != null:
		print("MarginContainer size: ", margin_container.size)
	if vbox_container != null:
		print("VBoxContainer size: ", vbox_container.size)
	if scroll_container != null:
		print("ScrollContainer size: ", scroll_container.size)
	if grid_container != null:
		print("GridContainer size: ", grid_container.size)
		print("Grid children: ", grid_container.get_child_count())
