# res://scripts/game/player/player_avatar.gd
class_name PlayerAvatar
extends Node2D

const CustomizationDefinitions = preload("res://data/player/customization_definitions.gd")

@export var default_body: String = "body_01"
@export var default_body_color: String = "skin_01"

@export var default_eyes: String = "eyes_01"

@export var default_clothes: String = "elf_mage"

@export var default_hair: String = "elf_mage_hair"
@export var default_hair_color: String = "default"

@export var default_hat: String = "wizard_hat"
@export var default_hat_color: String = "blue"

@export var default_staff: String = "oak_staff"

@export var default_spell: String = "fireball"

@onready var body_sprite: Sprite2D = %BodySprite
@onready var left_eye_color: ColorRect = %LeftEyeColor
@onready var right_eye_color: ColorRect = %RightEyeColor
@export var default_eyes_color: String = "eye_blue"
@onready var eyes_sprite: Sprite2D = %EyesSprite
@onready var boots_sprite: Sprite2D = %BootsSprite
@onready var clothes_lower_sprite: Sprite2D = %ClothesLowerSprite
@onready var left_hand_sprite: Sprite2D = %LeftHandSprite
@onready var clothes_upper_sprite: Sprite2D = %ClothesUpperSprite
@onready var hair_sprite: Sprite2D = %HairSprite
@onready var hat_sprite: Sprite2D = %HatSprite
@onready var staff_sprite: Sprite2D = %StaffSprite
@onready var right_hand_sprite: Sprite2D = %RightHandSprite

@onready var animation_player: AnimationPlayer = %AnimationPlayer

var equipped_body: String = ""
var equipped_body_color: String = ""

var equipped_eyes: String = ""
var equipped_eyes_color: String = ""

var equipped_clothes: String = ""

var equipped_hair: String = ""
var equipped_hair_color: String = ""

var equipped_hat: String = ""
var equipped_hat_color: String = ""

var equipped_staff: String = ""

var equipped_spell: String = ""


func _ready() -> void:
	equipped_body = default_body
	equipped_body_color = default_body_color

	equipped_eyes = default_eyes
	equipped_eyes_color = default_eyes_color

	equipped_clothes = default_clothes

	equipped_hair = default_hair
	equipped_hair_color = default_hair_color

	equipped_hat = default_hat
	equipped_hat_color = default_hat_color

	equipped_staff = default_staff

	equipped_spell = default_spell

	refresh_visuals()
	play_idle()


func apply_loadout(loadout: Dictionary) -> void:
	equipped_body = str(loadout.get("body", equipped_body))
	equipped_body_color = str(loadout.get("body_color", equipped_body_color))

	equipped_eyes = str(loadout.get("eyes", equipped_eyes))
	equipped_eyes_color = str(loadout.get("eyes_color", equipped_eyes_color))

	equipped_clothes = str(loadout.get("clothes", equipped_clothes))

	equipped_hair = str(loadout.get("hair", equipped_hair))
	equipped_hair_color = str(loadout.get("hair_color", equipped_hair_color))

	equipped_hat = str(loadout.get("hat", equipped_hat))
	equipped_hat_color = str(loadout.get("hat_color", equipped_hat_color))

	equipped_staff = str(loadout.get("staff", equipped_staff))

	equipped_spell = str(loadout.get("spell", equipped_spell))

	refresh_visuals()


func get_loadout() -> Dictionary:
	return {
		"body": equipped_body,
		"body_color": equipped_body_color,

		"eyes": equipped_eyes,
		"eyes_color": equipped_eyes_color,

		"clothes": equipped_clothes,

		"hair": equipped_hair,
		"hair_color": equipped_hair_color,

		"hat": equipped_hat,
		"hat_color": equipped_hat_color,

		"staff": equipped_staff,

		"spell": equipped_spell,
	}


func equip_part(slot_id: String, item_id: String) -> void:
	match slot_id:
		"body":
			equipped_body = item_id

		"body_color", "skin", "skin_color":
			equipped_body_color = item_id

		"eyes":
			equipped_eyes = item_id
		"eyes_color":
			equipped_eyes_color = item_id

		"clothes":
			equipped_clothes = item_id

		"hair":
			equipped_hair = item_id

		"hair_color":
			equipped_hair_color = item_id

		"hat":
			equipped_hat = item_id

		"hat_color":
			equipped_hat_color = item_id

		"staff":
			equipped_staff = item_id

		"spell":
			equipped_spell = item_id

		_:
			push_warning("PlayerAvatar: Unknown slot_id: " + slot_id)
			return

	refresh_visuals()


func refresh_visuals() -> void:
	_apply_body()
	_apply_eyes()
	_apply_clothes()

	_apply_part(
		hair_sprite,
		"hair",
		equipped_hair,
		equipped_hair_color
	)

	_apply_part(
		hat_sprite,
		"hat",
		equipped_hat,
		equipped_hat_color
	)

	_apply_part(
		staff_sprite,
		"staff",
		equipped_staff,
		"default"
	)


func play_idle() -> void:
	if animation_player == null:
		return

	if animation_player.has_animation("idle"):
		animation_player.play("idle")


func play_cast() -> void:
	if animation_player == null:
		return

	if animation_player.has_animation("cast"):
		animation_player.play("cast")


func _apply_body() -> void:
	_apply_part(
		body_sprite,
		"body",
		equipped_body,
		equipped_body_color,
		true
	)

	var skin_color: Color = (
		CustomizationDefinitions.get_body_color(
			equipped_body_color
		)
	)

	if left_hand_sprite != null:
		left_hand_sprite.modulate = skin_color

	if right_hand_sprite != null:
		right_hand_sprite.modulate = skin_color


func _apply_eyes() -> void:
	_apply_part(
		eyes_sprite,
		"eyes",
		equipped_eyes,
		"default"
	)

	var eye_color: Color = CustomizationDefinitions.get_eye_color(
		equipped_eyes_color
	)

	if left_eye_color != null:
		left_eye_color.visible = true
		left_eye_color.color = eye_color

	if right_eye_color != null:
		right_eye_color.visible = true
		right_eye_color.color = eye_color


func _apply_clothes() -> void:
	var textures: Dictionary = (
		CustomizationDefinitions.get_clothes_textures(
			equipped_clothes
		)
	)

	_apply_texture_to_sprite(
		boots_sprite,
		textures.get("boots", null),
		false
	)

	_apply_texture_to_sprite(
		clothes_lower_sprite,
		textures.get("lower", null),
		false
	)

	_apply_texture_to_sprite(
		clothes_upper_sprite,
		textures.get("upper", null),
		false
	)


func _apply_part(
	sprite: Sprite2D,
	slot_id: String,
	item_id: String,
	color_id: String,
	required: bool = false
) -> void:
	if sprite == null:
		return

	if item_id.is_empty() or item_id == "none":
		sprite.visible = required

		if not required:
			sprite.texture = null

		return

	var texture: Texture2D = (
		CustomizationDefinitions.get_texture(
			slot_id,
			item_id
		)
	)

	if texture == null:
		sprite.visible = false
		sprite.texture = null

		push_warning(
			"PlayerAvatar: Missing texture for %s / %s"
			% [slot_id, item_id]
		)

		return

	sprite.texture = texture
	sprite.visible = true

	if color_id == "default" or color_id.is_empty():
		sprite.modulate = Color.WHITE

	elif slot_id == "body":
		sprite.modulate = (
			CustomizationDefinitions.get_body_color(
				color_id
			)
		)

	else:
		sprite.modulate = (
			CustomizationDefinitions.get_dye_color(
				color_id
			)
		)


func _apply_texture_to_sprite(
	sprite: Sprite2D,
	texture: Texture2D,
	required: bool = false
) -> void:
	if sprite == null:
		return

	if texture == null:
		sprite.visible = required

		if not required:
			sprite.texture = null

		return

	sprite.texture = texture
	sprite.visible = true
	sprite.modulate = Color.WHITE
