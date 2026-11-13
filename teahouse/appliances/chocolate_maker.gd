extends Area2D

@onready var recipe_book = $"../RecipeBookUI"


func _input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if TeahouseData.appliances["chocolate_maker"]["owned"]:
					recipe_book.open_book("chocolate_maker")
