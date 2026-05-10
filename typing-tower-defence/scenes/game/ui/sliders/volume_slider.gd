extends HSlider

@export var bus_name: String = ""

var bus_index: int = -1

@onready var slider_label: Label = %slider_label


func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

	if bus_index == -1:
		push_error("Audio bus not found: " + bus_name)
		return

	min_value = 0.0
	max_value = 1.0
	step = 0.01

	value_changed.connect(_on_value_changed)

	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	_on_value_changed(value)


func _on_value_changed(new_value: float) -> void:
	if bus_index == -1:
		return

	var percent: int = roundi(new_value * 100.0)

	if slider_label != null:
		slider_label.text = str(percent)

	if new_value <= 0.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_value))
