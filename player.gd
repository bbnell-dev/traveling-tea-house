extends CharacterBody2D

@export var speed: float = 150.0

@onready var body_sprite: Sprite2D = $BodySprite
@onready var eyes_sprite: Sprite2D = $EyesSprite
@onready var hair_sprite: Sprite2D = $HairSprite
@onready var outfit_sprite: Sprite2D = $OutfitSprite

func _ready() -> void:
	load_appearance()
	
func load_appearance() -> void:
	PlayerData.load_character()
	
	body_sprite.texture = load(
		"res://assets/characters/bodies/female.png"
	)
	
	hair_sprite.texture = load(
		"res://assets/characters/hair/hair_%02d.png"
		% (PlayerData.hairstyle_index + 1)
	)
	
	outfit_sprite.texture = load(
		"res://assets/characters/outfits/outfit_%02d.png"
		% (PlayerData.outfit_index + 1)
	)
	
	eyes_sprite.texture = load(
		"res://assets/characters/eyes/eyes.png"
	)
	
	body_sprite.modulate = PlayerData.skin_color
	hair_sprite.modulate = PlayerData.hair_color
	eyes_sprite.modulate = PlayerData.eye_color
	
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)
	
	velocity = direction * speed
	move_and_slide()
	
