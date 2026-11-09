extends Control

@onready var new_game_button: Button = $CenterContainer/MenuLayout/NewGameButton
@onready var continue_button: Button = $CenterContainer/MenuLayout/ContinueButton
# @onready var settings_button: Button = $CenterContainer/MenuLayout/SettingsButton
@onready var quit_button: Button = $CenterContainer/MenuLayout/QuitButton

# @onready var settings_menu: Control = $SettingMenu

func _ready() -> void:
	new_game_button.pressed.connect(start_new_game)
	continue_button.pressed.connect(continue_game)
	# settings_button.pressed.connect(open_settings)
	quit_button.pressed.connect(quit_game)
	
	continue_button.disabled = FileAccess.file_exists(
		PlayerData.SAVE_PATH
	)
	
	# settings_menu.visible = false
	
func start_new_game() -> void:
	get_tree().change_scene_to_file(
		"res://character_creation.tscn"
	)
	
func continue_game() -> void:
	if PlayerData.load_character():
		get_tree().change_scene_to_file(
			"res://world.tscn"
		)
		
# func open_settings() -> void:
	# settings_menu.visible = true
	
func quit_game() -> void:
	get_tree().quit()
