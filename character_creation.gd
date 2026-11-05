extends Control

# Outfit index
var outfit_index = 0
const TOTAL_OUTFITS: int = 15

# Character cutomization choices
var hairstyle_index: int = 0

const TOTAL_HAIRSTYLES: int = 5

# Hair and eye colors
var selected_hair_color: Color = Color("#795548")
var selected_eye_color: Color = Color("#5385b5")
var selected_skin_color: Color = Color("#f0c7a8")

const SKIN_COLORS = {
	"SkinLight": "f8ddc6",
	"SkinFair": "f0c7a8",
	"SkinMedium": "d8a078",
	"SkinTan": "b97b52",
	"SkinDeep": "865039",
	"SkinDark": "573426"
}

const HAIR_COLORS = {
	"HairBlack": "#282329",
	"HairBrown": "#795548",
	"HairBlonde": "#e6bd71",
	"HairRed": "#b94e35",
	"HairWhite": "#eee8dd"
}

const EYE_COLORS = {
	"EyeBrown": "#704b36",
	"EyeBlue": "#5385b5",
	"EyeGreen": "#588c67",
	"EyeGray": "#929ba5"
}

const HAIR_TEXTURES = [
	preload("res://assets/characters/hair/hair_01.png"),
	preload("res://assets/characters/hair/hair_02.png"),
	preload("res://assets/characters/hair/hair_03.png"),
	preload("res://assets/characters/hair/hair_04.png"),
	preload("res://assets/characters/hair/hair_05.png")
]

const OUTFIT_TEXTURES = [
	preload("res://assets/characters/outfits/outfit_01.png"),
	preload("res://assets/characters/outfits/outfit_02.png"),
	preload("res://assets/characters/outfits/outfit_03.png"),
	preload("res://assets/characters/outfits/outfit_04.png"),
	preload("res://assets/characters/outfits/outfit_05.png"),
	preload("res://assets/characters/outfits/outfit_06.png"),
	preload("res://assets/characters/outfits/outfit_07.png"),
	preload("res://assets/characters/outfits/outfit_07.png"),
	preload("res://assets/characters/outfits/outfit_08.png"),
	preload("res://assets/characters/outfits/outfit_09.png"),
	preload("res://assets/characters/outfits/outfit_10.png"),
	preload("res://assets/characters/outfits/outfit_11.png"),
	preload("res://assets/characters/outfits/outfit_12.png"),
	preload("res://assets/characters/outfits/outfit_13.png"),
	preload("res://assets/characters/outfits/outfit_14.png"),
	preload("res://assets/characters/outfits/outfit_15.png")
]

# Outfit picker
@onready var previous_outfit_button: Button = $MainLayout/CustomizationPanel/CusomizationLayout/OutfitLabel/OutfitOptions/PreviousOutfitButton
@onready var next_outfit_button: Button = $MainLayout/CustomizationPanel/CusomizationLayout/OutfitLabel/OutfitOptions/NextOutfitButton
@onready var outfit_value: Label = $MainLayout/CustomizationPanel/CusomizationLayout/OutfitLabel/OutfitOptions/OutfitValue

# Save character
@onready var name_input: LineEdit = $MainLayout/CustomizationPanel/CusomizationLayout/NameInput
@onready var create_button: Button = $MainLayout/CustomizationPanel/CusomizationLayout/CreateCharacterButton

# Skin color picker
@onready var skin_picker: ColorPickerButton = $MainLayout/CustomizationPanel/CusomizationLayout/SkinColorPresets/SkinColorPicker
@onready var skin_presets: HBoxContainer = $MainLayout/CustomizationPanel/CusomizationLayout/SkinColorPresets

# Hairstyle options
@onready var previous_hair_button: Button = $MainLayout/CustomizationPanel/CusomizationLayout/HairstyleOptions/PreviousHairButton
@onready var next_hair_button: Button = $MainLayout/CustomizationPanel/CusomizationLayout/HairstyleOptions/NextHairButton
@onready var hairstyle_value: Label = $MainLayout/CustomizationPanel/CusomizationLayout/HairstyleOptions/HairstyleValue

# Color picking buttons for hair & eyes
@onready var hair_picker: ColorPickerButton = $MainLayout/CustomizationPanel/CusomizationLayout/HairColorPicker
@onready var eye_picker: ColorPickerButton = $MainLayout/CustomizationPanel/CusomizationLayout/EyeColorPicker

@onready var hair_presets: HBoxContainer = $MainLayout/CustomizationPanel/CusomizationLayout/HairColorPresets
@onready var eye_presets: HBoxContainer = $MainLayout/CustomizationPanel/CusomizationLayout/EyeColorPresets

# Preview
@onready var body_sprite: Sprite2D = $MainLayout/CharacterPreviewPanel/PreviewLayout/CharacterDisplay/PreviewViewport/CharacterPreview/BodySprite
@onready var eyes_sprite: Sprite2D = $MainLayout/CharacterPreviewPanel/PreviewLayout/CharacterDisplay/PreviewViewport/CharacterPreview/EyesSprite
@onready var hair_sprite: Sprite2D = $MainLayout/CharacterPreviewPanel/PreviewLayout/CharacterDisplay/PreviewViewport/CharacterPreview/HairSprite
@onready var outfit_sprite: Sprite2D = $MainLayout/CharacterPreviewPanel/PreviewLayout/CharacterDisplay/PreviewViewport/CharacterPreview/OutfitSprite

func _ready() -> void:
	
	previous_outfit_button.pressed.connect(previous_outfit)
	next_outfit_button.pressed.connect(next_outfit)
	update_outfit_label()
	
	create_button.pressed.connect(create_character)
	
	skin_picker.color = selected_skin_color
	skin_picker.color_changed.connect(set_skin_color)

	setup_skin_presets()
	
	previous_hair_button.pressed.connect(previous_hairstyle)
	next_hair_button.pressed.connect(next_hairstyle)
	
	update_hairstyle_label()
	
	hair_picker.color = selected_hair_color
	eye_picker.color = selected_eye_color
	
	hair_picker.color_changed.connect(set_hair_color)
	eye_picker.color_changed.connect(set_eye_color)
	
	setup_color_presets(hair_presets, HAIR_COLORS, true)
	setup_color_presets(eye_presets, EYE_COLORS, false)
	
func previous_hairstyle() -> void:
	hairstyle_index = wrapi(hairstyle_index - 1, 0, TOTAL_HAIRSTYLES)
	update_hairstyle_label()

func next_hairstyle() -> void:
	hairstyle_index = wrapi(hairstyle_index + 1, 0, TOTAL_HAIRSTYLES)
	update_hairstyle_label()
	
func update_hairstyle_label() -> void:
	hairstyle_value.text = "Style %d / %d" % [
		hairstyle_index + 1,
		TOTAL_HAIRSTYLES
	]
	
	hair_sprite.texture = HAIR_TEXTURES[hairstyle_index]

func setup_color_presets(container: HBoxContainer, colors: Dictionary, is_hair: bool) -> void:
	for button_name in colors:
		var button: Button = container.get_node(button_name)
		var color:= Color(colors[button_name])
		
		var style := StyleBoxFlat.new()
		style.bg_color = color
		style.set_corner_radius_all(5)
		style.set_border_width_all(1)
		style.border_color = Color("#777777")
		
		button.add_theme_stylebox_override("normal", style)
		button.add_theme_stylebox_override("hover", style)
		button.add_theme_stylebox_override("pressed", style)
		
		if is_hair:
			button.pressed.connect(set_hair_color.bind(color))
		else:
			button.pressed.connect(set_eye_color.bind(color))
			
func set_hair_color(color: Color) -> void:
	selected_hair_color = color
	hair_picker.color = color
	hair_sprite.modulate = color
	
func set_eye_color(color: Color) -> void:
	selected_eye_color = color
	eye_picker.color = color
	eyes_sprite.modulate = color
	

func setup_skin_presets() -> void:
	for button_name in SKIN_COLORS:
		var button: Button = skin_presets.get_node(button_name)
		var color := Color(SKIN_COLORS[button_name])

		var style := StyleBoxFlat.new()
		style.bg_color = color
		style.set_corner_radius_all(5)
		style.set_border_width_all(1)
		style.border_color = Color("#777777")

		button.add_theme_stylebox_override("normal", style)
		button.add_theme_stylebox_override("hover", style)
		button.add_theme_stylebox_override("pressed", style)

		button.pressed.connect(set_skin_color.bind(color))
		

func set_skin_color(color: Color) -> void:
	selected_skin_color = color
	skin_picker.color = color
	body_sprite.modulate = color

func create_character() -> void:
	var chosen_name = name_input.text.strip_edges()
	
	if chosen_name.is_empty():
		name_input.grab_focus()
		return
		
	PlayerData.character_name = chosen_name
	PlayerData.hairstyle_index = hairstyle_index
	PlayerData.outfit_index = outfit_index
	
	PlayerData.skin_color = selected_skin_color
	PlayerData.hair_color = selected_hair_color
	PlayerData.eye_color = selected_eye_color
	
	PlayerData.save_character()
	
	print("Character saved: ", chosen_name)

# Outfit button functions
func previous_outfit() -> void:
	outfit_index = wrapi(outfit_index - 1, 0, TOTAL_OUTFITS)
	update_outfit_label()
	
func next_outfit() -> void:
	outfit_index = wrapi(outfit_index + 1, 0, TOTAL_OUTFITS)
	update_outfit_label()
	
func update_outfit_label() -> void:
	outfit_value.text = "Outfit %d / %d" % [
		outfit_index + 1,
		TOTAL_OUTFITS
	]
	
	outfit_sprite.texture = load(
		"res://assets/characters/outfits/outfit_%02d.png" % (outfit_index + 1)
	)
