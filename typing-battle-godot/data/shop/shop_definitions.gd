class_name ShopDefinitions

const UPGRADES := {
	"repair_base": {
		"display_name": "Repair",
		"base_cost": 20,
		"cost_scaling": 0,
		"max_level": -1,
		"value_per_level": 5,
		"description": "Restore {value} base HP."
	},
	"word_damage": {
		"display_name": "Word Damage",
		"base_cost": 25,
		"cost_scaling": 15,
		"max_level": 10,
		"value_per_level": 1,
		"description": "+{value} typing damage."
	},
	"arrow_damage": {
		"display_name": "Arrow Damage",
		"base_cost": 30,
		"cost_scaling": 20,
		"max_level": 10,
		"value_per_level": 1,
		"description": "+{value} arrow damage."
	},
	"arrow_meter_gain": {
		"display_name": "Arrow Charge",
		"base_cost": 35,
		"cost_scaling": 20,
		"max_level": 10,
		"value_per_level": 5,
		"description": "+{value} arrow meter gain per word."
	},
	"gold_gain": {
		"display_name": "Gold Gain",
		"base_cost": 40,
		"cost_scaling": 25,
		"max_level": 10,
		"value_per_level": 0.25,
		"description": "+{value}x gold multiplier."
	}
}
