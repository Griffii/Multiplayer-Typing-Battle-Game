# res://data/player/customization_definitions.gd

const ITEMS: Dictionary = {
	"body": {
		"body_01": {
			"display_name": "Body",
			"texture": preload("uid://5gjqrykuhyxd"),
			"available_dyes": [
				"skin_01",
				"skin_02",
				"skin_03",
				"skin_04",
				"skin_05",
				"skin_06",
				"skin_red",
				"skin_purple",
				"skin_pink"
			],
			"unlock_hint": "",
			"bonuses": {}
		}
	},

	"body_color": {
		"skin_01": {"display_name": "Skin 1", "color": Color("#ffffff"), "unlock_hint": "", "bonuses": {}},
		"skin_02": {"display_name": "Skin 2", "color": Color("#f3c7a6"), "unlock_hint": "", "bonuses": {}},
		"skin_03": {"display_name": "Skin 3", "color": Color("#d99a6c"), "unlock_hint": "", "bonuses": {}},
		"skin_04": {"display_name": "Skin 4", "color": Color("#a96b46"), "unlock_hint": "", "bonuses": {}},
		"skin_05": {"display_name": "Skin 5", "color": Color("#70452f"), "unlock_hint": "", "bonuses": {}},
		"skin_06": {"display_name": "Skin 6", "color": Color("#3f2419"), "unlock_hint": "", "bonuses": {}},
		"skin_red": {"display_name": "Red Skin", "color": Color("#d94b4b"), "unlock_hint": "Go to the underworld.", "bonuses": {}},
		"skin_purple": {"display_name": "Purple Skin", "color": Color("#9b5de5"), "unlock_hint": "Go to space.", "bonuses": {}},
		"skin_pink": {"display_name": "Pink Skin", "color": Color("#ff8fab"), "unlock_hint": "Eat a donut.", "bonuses": {}}
	},

	"eyes": {
		"eyes_01": {
			"display_name": "Eyes 01",
			"texture": preload("uid://doffoan6o17oo"),
			"available_dyes": [
				"eye_blue",
				"eye_green",
				"eye_brown",
				"eye_gold",
				"eye_purple",
				"eye_red"
			],
			"unlock_hint": "",
			"bonuses": {}
		}
	},
	
	"eyes_color": {
		"eye_blue": {"display_name": "Blue Eyes", "color": Color("#4f9cff"), "unlock_hint": "", "bonuses": {}},
		"eye_green": {"display_name": "Green Eyes", "color": Color("#5bbf73"), "unlock_hint": "", "bonuses": {}},
		"eye_brown": {"display_name": "Brown Eyes", "color": Color("#7a4a2a"), "unlock_hint": "", "bonuses": {}},
		"eye_gold": {"display_name": "Gold Eyes", "color": Color("#f0c84b"), "unlock_hint": "", "bonuses": {}},
		"eye_purple": {"display_name": "Purple Eyes", "color": Color("#9b5de5"), "unlock_hint": "", "bonuses": {}},
		"eye_red": {"display_name": "Red Eyes", "color": Color("#d94b4b"), "unlock_hint": "", "bonuses": {}}
	},

	"clothes": {
		"wizard_robes": {
			"display_name": "Wizard Robes",
			"boots_texture": preload("uid://ct758fe20jc7"),
			"lower_texture": preload("uid://c1hkp1kxgf7er"),
			"upper_texture": null,
			"item_icon": preload("uid://c1hkp1kxgf7er"),
			"available_dyes": [
				"default",
				"white",
				"blue",
				"red",
				"green",
				"gray",
				"black",
				"purple",
				"pink"
			],
			"unlock_hint": "",
			"bonuses": {}
		},
		"elf_mage": {
			"display_name": "Elf Mage",
			"boots_texture": preload("uid://ct758fe20jc7"),
			"lower_texture": preload("uid://dunbfqxqpxlqa"),
			"upper_texture": preload("uid://cuk84b23uff16"),
			"item_icon": preload("uid://nhq0kinl2swy"),
			"available_dyes": ["default"],
			"unlock_hint": "",
			"bonuses": {}
		},
		
	},

	"hair": {
		"short_hair": {
			"display_name": "Short Hair",
			"texture": preload("uid://dpgpheugk04go"),
			"available_dyes": [
				"default",
				"blonde",
				"brown",
				"dark_brown",
				"black",
				"red_hair",
				"blue",
				"purple",
				"pink"
			],
			"unlock_hint": "",
			"bonuses": {}
		},
		"long_hair": {
			"display_name": "Long Hair",
			"texture": preload("uid://47xvk48c6sav"),
			"available_dyes": [
				"default",
				"blonde",
				"brown",
				"dark_brown",
				"black",
				"red_hair",
				"blue",
				"purple",
				"pink"
			],
			"unlock_hint": "",
			"bonuses": {}
		},
		"elf_mage_hair": {
			"display_name": "Elf Mage",
			"texture": preload("uid://3bjheayrme3u"),
			"available_dyes": [
				"default",
			],
			"unlock_hint": "",
			"bonuses": {}
		},
	},

	"hat": {
		"wizard_hat": {
			"display_name": "Wizard Hat",
			"texture": preload("uid://cilpqii56rjy2"),
			"available_dyes": [
				"default",
				"white",
				"blue",
				"red",
				"green",
				"gray",
				"black",
				"purple",
				"pink"
			],
			"unlock_hint": "",
			"bonuses": {}
		}
	},

	"staff": {
		"oak_staff": {
			"display_name": "Oak Staff",
			"texture": preload("uid://br3evirrpdtvp"),
			"available_dyes": ["default"],
			"unlock_hint": "",
			"bonuses": {}
		},
		"glass_staff": {
			"display_name": "Glass Staff",
			"texture": preload("uid://bcl5ob8o0fb24"),
			"available_dyes": ["default"],
			"unlock_hint": "Locked",
			"bonuses": {}
		},
		"elf_mage_staff": {
			"display_name": "Elf Mage Staff",
			"texture": preload("uid://dhqffpjlon15w"),
			"available_dyes": ["default"],
			"unlock_hint": "",
			"bonuses": {}
		}
	}
}


const DYES: Dictionary = {
	"default": {"display_name": "Default", "color": Color.WHITE, "unlock_hint": ""},
	"white": {"display_name": "White", "color": Color("#ffffff"), "unlock_hint": ""},
	"beige": {"display_name": "Beige", "color": Color("#d8b894"), "unlock_hint": ""},
	"gray": {"display_name": "Gray", "color": Color("#aaaaaa"), "unlock_hint": ""},
	"blue": {"display_name": "Blue", "color": Color("#4f7cff"), "unlock_hint": ""},
	"red": {"display_name": "Red", "color": Color("#d94b4b"), "unlock_hint": ""},
	"green": {"display_name": "Green", "color": Color("#5bbf73"), "unlock_hint": ""},
	"brown": {"display_name": "Brown", "color": Color("#7a4a2a"), "unlock_hint": ""},
	"dark_brown": {"display_name": "Dark Brown", "color": Color("#3a2416"), "unlock_hint": ""},
	"black": {"display_name": "Black", "color": Color("#202020"), "unlock_hint": ""},
	"blonde": {"display_name": "Blonde", "color": Color("#e8c76f"), "unlock_hint": ""},
	"pink": {"display_name": "Pink", "color": Color("#ff8fab"), "unlock_hint": ""},
	"purple": {"display_name": "Purple", "color": Color("#9b5de5"), "unlock_hint": ""},
	"red_hair": {"display_name": "Red Hair", "color": Color("#b9472a"), "unlock_hint": ""}
}


static func has_item(slot_id: String, item_id: String) -> bool:
	return ITEMS.has(slot_id) and ITEMS[slot_id].has(item_id)


static func get_item_data(slot_id: String, item_id: String) -> Dictionary:
	if not has_item(slot_id, item_id):
		return {}

	var data: Dictionary = ITEMS[slot_id][item_id].duplicate(true)

	if data.has("texture") and not data.has("item_icon"):
		data["item_icon"] = data["texture"]

	return data


static func get_items_for_slot(slot_id: String) -> Dictionary:
	if not ITEMS.has(slot_id):
		return {}

	return ITEMS[slot_id].duplicate(true)


static func get_texture(slot_id: String, item_id: String) -> Texture2D:
	var data: Dictionary = get_item_data(slot_id, item_id)
	return data.get("texture", null)


static func get_clothes_textures(item_id: String) -> Dictionary:
	var data: Dictionary = get_item_data("clothes", item_id)

	return {
		"boots": data.get("boots_texture", null),
		"lower": data.get("lower_texture", null),
		"upper": data.get("upper_texture", null),
	}


static func get_body_color(color_id: String) -> Color:
	var data: Dictionary = get_item_data("body_color", color_id)
	return data.get("color", Color.WHITE)


static func get_eye_color(color_id: String) -> Color:
	var data: Dictionary = get_item_data("eyes_color", color_id)
	return data.get("color", Color("#4f9cff"))


static func get_dye_data(dye_id: String) -> Dictionary:
	if not DYES.has(dye_id):
		return {}

	var data: Dictionary = DYES[dye_id].duplicate(true)
	data["bonuses"] = {}
	return data


static func get_dye_color(dye_id: String) -> Color:
	var data: Dictionary = get_dye_data(dye_id)
	return data.get("color", Color.WHITE)


static func get_dye_display_name(dye_id: String) -> String:
	var data: Dictionary = get_dye_data(dye_id)
	return str(data.get("display_name", dye_id))


static func get_bonuses(slot_id: String, item_id: String) -> Dictionary:
	var data: Dictionary = get_item_data(slot_id, item_id)
	return data.get("bonuses", {}).duplicate(true)


static func get_available_dyes_for_item(slot_id: String, item_id: String) -> Array[String]:
	var result: Array[String] = []
	var data: Dictionary = get_item_data(slot_id, item_id)

	var dyes: Array = data.get("available_dyes", [])
	for dye_id_variant in dyes:
		result.append(str(dye_id_variant))

	return result
