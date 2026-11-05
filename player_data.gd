extends Node

# Saves player apperance
var character_name: String = ""
var hairstyle_index: int = 0
var outfit_index: int = 0

var skin_color: Color = Color("#f0c7a8")
var hair_color: Color = Color("#795548")
var eye_color: Color = Color("#5385b5")

const SAVE_PATH = "user://player_data.json"

func save_character() -> void:
	var data = {
		"name": character_name,
		"hairstyle": hairstyle_index,
		"outfit": outfit_index,
		"skin_color": skin_color,
		"hair_color": hair_color,
		"eye_color": eye_color
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if file == null:
		push_error("Could not save character.")
		return
		
	file.store_string(JSON.stringify(data))
	file.close()
	
func load_character() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	
	if file == null:
		return false
		
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	
	if not data is Dictionary:
		return false
		
	character_name = str(data.get("name", ""))
	hairstyle_index = int(data.get("hairstyle", 0))
	outfit_index = int(data.get("outfit", 0))
	
	skin_color = Color(str(data.get("skin_color", "#f0c7a8")))
	hair_color = Color(str(data.get("hair_color", "#795548")))
	eye_color = Color(str(data.get("eye_color", "#5385b5")))
	
	return true
