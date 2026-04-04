# res://data/waves/wave_set_01.gd
class_name WaveSet01

const WAVES := [
	{
		"spawn_interval": 1.20,
		"wave_word_list": "easy",
		"enemies": [
			{"enemy_type": "grunt"},
			{"enemy_type": "grunt"},
			{"enemy_type": "scout"},
			{"enemy_type": "grunt"},
			{"enemy_type": "grunt"},
			{"enemy_type": "grunt"},
			{"enemy_type": "scout"}
		]
	},
	{
		"spawn_interval": 1.10,
		"wave_word_list": "easy",
		"enemies": [
			{"enemy_type": "grunt"},
			{"enemy_type": "scout"},
			{"enemy_type": "grunt"},
			{"enemy_type": "grunt"},
			{"enemy_type": "scout"},
			{"enemy_type": "grunt"},
			{"enemy_type": "grunt"}
		]
	},
	{
		"spawn_interval": 1.05,
		"wave_word_list": "easy",
		"enemies": [
			{"enemy_type": "grunt"},
			{"enemy_type": "scout"},
			{"enemy_type": "grunt"},
			{"enemy_type": "tank", "word_list": "medium"},
			{"enemy_type": "grunt"},
			{"enemy_type": "scout"},
			{"enemy_type": "grunt"}
		]
	},
	{
		"spawn_interval": 1.00,
		"wave_word_list": "easy",
		"enemies": [
			{"enemy_type": "scout"},
			{"enemy_type": "grunt"},
			{"enemy_type": "scout"},
			{"enemy_type": "grunt"},
			{"enemy_type": "tank", "word_list": "medium"},
			{"enemy_type": "grunt"},
			{"enemy_type": "scout"},
			{"enemy_type": "grunt"}
		]
	},
	{
		"spawn_interval": 0.98,
		"wave_word_list": "medium",
		"enemies": [
			{"enemy_type": "grunt"},
			{"enemy_type": "grunt"},
			{"enemy_type": "tank"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "grunt"},
			{"enemy_type": "tank"},
			{"enemy_type": "grunt"},
			{"enemy_type": "scout", "word_list": "easy"}
		]
	},
	{
		"spawn_interval": 0.95,
		"wave_word_list": "medium",
		"enemies": [
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "grunt"},
			{"enemy_type": "tank"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "grunt"},
			{"enemy_type": "tank"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "grunt"},
			{"enemy_type": "grunt"}
		]
	},
	{
		"spawn_interval": 0.92,
		"wave_word_list": "medium",
		"enemies": [
			{"enemy_type": "grunt"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "tank"},
			{"enemy_type": "grunt"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "tank"},
			{"enemy_type": "grunt"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "grunt"},
			{"enemy_type": "tank"}
		]
	},
	{
		"spawn_interval": 0.90,
		"wave_word_list": "medium",
		"enemies": [
			{"enemy_type": "tank"},
			{"enemy_type": "grunt"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "grunt"},
			{"enemy_type": "tank"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "grunt"},
			{"enemy_type": "tank"},
			{"enemy_type": "grunt"},
			{"enemy_type": "scout", "word_list": "easy"}
		]
	},
	{
		"spawn_interval": 0.88,
		"wave_word_list": "medium",
		"enemies": [
			{"enemy_type": "grunt", "word_list": "medium"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "tank", "word_list": "medium"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "grunt", "word_list": "medium"},
			{"enemy_type": "tank", "word_list": "medium"},
			{"enemy_type": "grunt", "word_list": "medium"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "tank", "word_list": "medium"},
			{"enemy_type": "grunt", "word_list": "medium"},
			{"enemy_type": "scout", "word_list": "easy"}
		]
	},
	{
		"spawn_interval": 1.00,
		"wave_word_list": "medium",
		"enemies": [
			{"enemy_type": "grunt", "word_list": "medium"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "tank", "word_list": "medium"},
			{"enemy_type": "grunt", "word_list": "medium"},
			{"enemy_type": "scout", "word_list": "easy"},
			{"enemy_type": "tank", "word_list": "medium"},
			{"enemy_type": "grunt", "word_list": "medium"},
			{"enemy_type": "boss", "word_list": "boss"}
		]
	}
]
