extends Node

const INGREDIENT_GROUPS = {
	"Produce": [
		"Lemon",
		"Lettuce",
		"Spinach",
		"Onion",
		"Tomato",
		"Apple",
		"Banana",
		"Blueberry",
		"Buckthorn",
		"Cocoa Bean",
		"Elderberry",
		"Raspberry",
		"Strawberry",
		"Button Mushroom"
	],
	"Herbs & Flowers": [
		"Chamomile",
		"Lavender",
		"Mint",
		"Rosehip",
		"Sea Fennel",
		"Thyme",
		"Vanilla Bean",
		"Moonpetal"
	],
	"Tea & Coffee": [
		"Coffee Bean",
		"Matcha Powder"
	],
	"Sweets": [
		"Chocolate",
		"Honey",
		"Sugar",
		"Blueberry Jam",
		"Lavender Syrup",
		"Raspberry Jam",
		"Strawberry Jam",
		"Vanilla Syrup"
	],
	"Grains, Breads & Spices": [
		"Flour",
		"Oats",
		"Wheat",
		"Banana Bread",
		"Bread",
		"Cardamon",
		"Chai Spice Mix",
		"Cinnamon",
		"Ginger",
		"Salt"
	],
	"Dairy, Eggs & Seafood": [
		"Butter",
		"Cheese",
		"Eggs",
		"Herb Butter",
		"Milk",
		"Artic Char",
		"Mussels",
		"Rainbow Trout"
	],
	"Other": [
		"Water"
	]
}

var ingredients: Dictionary = {}

func _ready() -> void:
	for category in INGREDIENT_GROUPS:
		for ingredient_name in INGREDIENT_GROUPS[category]:
			var item_id: String = String(
				ingredient_name
			).to_lower().replace(" ", "_")
			
			ingredients[item_id] = {
				"id": item_id,
				"name": ingredient_name,
				"category": category,
				"max_stack": 99
			}
			
func get_ingredient(item_id: String) -> Dictionary:
	return ingredients.get(item_id, {})
	
func has_ingredient(item_id: String) -> bool:
	return ingredients.has(item_id)
