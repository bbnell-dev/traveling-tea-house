extends CanvasLayer

@onready var book_panel: PanelContainer = $BookPanel
@onready var book_title: Label = $BookPanel/MarginContainer/VBoxContainer/BookTitle
@onready var recipe_list: VBoxContainer = $BookPanel/MarginContainer/VBoxContainer/RecipeList
@onready var close_button: Button = $BookPanel/MarginContainer/VBoxContainer/CloseButton


func _ready() -> void:
	book_panel.hide()
	close_button.pressed.connect(close_book)


func open_book(appliance_id: String) -> void:
	# Remove recipes from the previous appliance.
	for child in recipe_list.get_children():
		recipe_list.remove_child(child)
		child.queue_free()

	var appliance: Dictionary = TeahouseData.appliances.get(
		appliance_id, {}
	)

	if appliance.is_empty():
		return

	book_title.text = appliance["name"] + " Recipes"

	var unlocked_recipes := TeahouseData.get_unlocked_recipes(
		appliance_id
	)

	if unlocked_recipes.is_empty():
		var empty_label := Label.new()
		empty_label.text = "No recipes unlocked yet."
		recipe_list.add_child(empty_label)

	for recipe in unlocked_recipes:
		var button := Button.new()
		button.text = recipe["name"]
		recipe_list.add_child(button)

		button.pressed.connect(
			_select_recipe.bind(recipe["id"])
		)

	book_panel.show()



func _select_recipe(recipe_id: String) -> void:
	var recipe: Dictionary = TeahouseData.recipes.get(
		recipe_id, {}
	)

	if recipe.is_empty():
		return

	book_title.text = recipe["name"]

	for child in recipe_list.get_children():
		recipe_list.remove_child(child)
		child.queue_free()

	var heading := Label.new()
	heading.text = "Required Ingredients:"
	recipe_list.add_child(heading)

	if recipe.has("ingredients"):
		for ingredient_id in recipe["ingredients"]:
			var amount: int = recipe["ingredients"][ingredient_id]

			var ingredient := IngredientDatabase.get_ingredient(
				ingredient_id
			)

			var ingredient_label := Label.new()
			ingredient_label.text = (
				ingredient.get("name", ingredient_id)
				+ " x" + str(amount)
			 )

			recipe_list.add_child(ingredient_label)

	var back_button := Button.new()
	back_button.text = "Back to Recipes"
	recipe_list.add_child(back_button)
	back_button.pressed.connect(
		open_book.bind(recipe["appliance"])
	)



func close_book() -> void:
	book_panel.hide()
