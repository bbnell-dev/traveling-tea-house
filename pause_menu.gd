extends CanvasLayer

@onready var resume_button: Button = $MenuCenter/MenuPanel/MenuLayout/ResumeButton
@onready var save_button: Button = $MenuCenter/MenuPanel/MenuLayout/SaveButton
@onready var main_menu_button: Button = $MenuCenter/MenuPanel/MenuLayout/MainMenuButton
@onready var quit_button: Button = $MenuCenter/MenuPanel/MenuLayout/QuitButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	resume_button.pressed.connect(resume_game)
	save_button.pressed.connect(save_game)
	# settings_button.pressed.connect(open_settings)
	main_menu_button.pressed.connect(return_to_menu)
	quit_button.pressed.connect(quit_game)
	
	# settings_menu.visible = false
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_P or event.keycode == KEY_ESCAPE:
				toggle_pause()
				get_viewport().set_input_as_handled()
				
func toggle_pause() -> void:
	if visible:
		resume_game()
	else:
		visible = true
		get_tree().paused = true
		
func resume_game() -> void:
	# settings_menu.visible = false
	visible = false
	get_tree().paused = false
	
func save_game() -> void:
	PlayerData.save_character()
	
# func open_settings() -> void:
	# settings_menu.visible = true
	
func return_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(
		"res://main_menu.tscn"
	)

func quit_game() -> void:
	get_tree().paused = false
	get_tree().quit()
