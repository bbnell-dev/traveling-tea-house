extends Button

@onready var pause_menu = $"../../PauseMenu"


func _pressed() -> void:
	pause_menu.toggle_pause()
