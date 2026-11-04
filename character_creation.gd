extends Control

# Character cutomization choices
var selected_body: String = "female"
var hairstyle_index: int = 0

const TOTAL_HAIRSTYLES: int = 5

# Hair and eye colors
var selected_hair_color: Color = Color("#795548")
var selected_eye_color: Color = Color("#5385b5")

const HAIR_COLORS = {
	"HairBlack": "#282329",
	"HairBrown": "#795548",
	"HairBlonde": "#e6bd71",
	"HairRed": "#b94e35",
	"HairWhite": "#eee8dd"
}

const EYE_COLORS = {
	"EyeBrown": "704b36",
	"EyeBlue": "#5385b5",
	"EyeGreen": "#588c67",
	"EyeGray": "#929ba5"
}

# Body preset buttons
@onready var female_button: TextureButton = $MainLayout/CustomizationPanel/CusomizationLayout/BodyTypeOptions/FemaleButton
@onready var male_button: TextureButton = $MainLayout/CustomizationPanel/CusomizationLayout/BodyTypeOptions/MaleButton

# Hairstyle options
@onready var previous_hair_button: Button = $MainLayout/CustomizationPanel/CusomizationLayout/HairstyleOptions/PreviousHairButton
@onready var next_hair_button: Button = $MainLayout/CustomizationPanel/CusomizationLayout/HairstyleOptions/NextHairButton
@onready var hairstyle_value: Label = $MainLayout/CustomizationPanel/CusomizationLayout/HairstyleOptions/HairstyleValue

# Color picking buttons for hair & eyes
@onready var hair_picker: ColorPickerButton = $MainLayout/CustomizationPanel/CusomizationLayout/HairColorPicker
@onready var eye_picker: ColorPickerButton = $MainLayout/CustomizationPanel/CusomizationLayout/EyeColorPicker

@onready var hair_presets: HBoxContainer = $MainLayout/CustomizationPanel/CusomizationLayout/HairColorPresets
@onready var eye_presets: HBoxContainer = $MainLayout/CustomizationPanel/CusomizationLayout/EyeColorPresets

func _ready() -> void:
	female_button.pressed.connect(select_female)
	male_button.pressed.connect(select_male)
	
	previous_hair_button.pressed.connect(previous_hairstyle)
	next_hair_button.pressed.connect(next_hairstyle)
	
	female_button.set_pressed_no_signal(true)
	male_button.set_pressed_no_signal(false)
	update_hairstyle_label()
	
	hair_picker.color = selected_hair_color
	eye_picker.color = selected_eye_color
	
	hair_picker.color_changed.connect(set_hair_color)
	eye_picker.color_changed.connect(set_eye_color)
	
	setup_color_presets(hair_presets, HAIR_COLORS, true)
	setup_color_presets(eye_presets, EYE_COLORS, false)
	
func select_female() -> void:
	selected_body = "female"
	female_button.set_pressed_no_signal(true)
	male_button.set_pressed_no_signal(false)

func select_male() -> void:
	selected_body = "male"
	male_button.set_pressed_no_signal(true)
	female_button.set_pressed_no_signal(false)
	
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
	
func set_eye_color(color: Color) -> void:
	selected_eye_color = color
	eye_picker.color = color
	
