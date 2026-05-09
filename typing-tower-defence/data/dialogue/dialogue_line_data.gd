# res://scripts/data/dialogue/dialogue_line_data.gd
class_name DialogueLineData
extends Resource

@export var speaker_id: String = ""
@export_multiline var text: String = ""

@export_enum("left", "center", "right") var position_override: String = ""
@export var expression: String = ""
@export var animation_name: String = ""
@export var wait_after_seconds: float = 0.0
