# res://data/dialogue/dialogue_speaker_data.gd
class_name DialogueSpeakerData
extends Resource

@export var speaker_id: String = ""
@export var display_name: String = ""
@export var use_player_name: bool = false

@export var avatar_scene: PackedScene

@export_enum(
	"left",
	"left_1",
	"left_2",
	"center",
	"center_1",
	"center_2",
	"right",
	"right_1",
	"right_2",
	"offscreen_left",
	"offscreen_right"
) var default_position: String = "left"

@export var dialogue_box_style: StyleBox
@export var name_color: Color = Color.WHITE
