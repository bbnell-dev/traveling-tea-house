extends Node

# This will remember which region the tea house is in.
var current_region: String = "wrenwood"

# Used when returning to the outside world.
var return_scene: String = ""

# Appliances owned by the player.
# Unlocked temporarily for testing.
var appliances: Dictionary = {
#region APPLIANCES
	"cooking_pot": {
		"name": "Cooking Pot",
		"owned": true,
		"unlock_requirement": "Bellmont"
	},
	"blender": {
		"name": "Blender",
		"owned": true,
		"unlock_requirement": "Wrenwood"
	},
	"coffee_station": {
		"name": "Coffee Station",
		"owned": true,
		"unlock_requirement": "Bellmont"
	},
	"tea_station": {
		"name": "Tea Station",
		"owned": true,
		"unlock_requirement": "Wrenwood"
	},
	"bread_counter": {
		"name": "Bread Counter",
		"owned": true,
		"unlock_requirement": "Bellmont"
	},
	"bakery_oven": {
		"name": "Bakery Oven",
		"owned": true,
		"unlock_requirement": "Bellmont"
	},
	"pestle_mortar": {
		"name": "Pestle & Mortar",
		"owned": true,
		"unlock_requirement": "Bellmont"
	},
	"preserving_station": {
		"name": "Preserving Station",
		"owned": true,
		"unlock_requirement": "Bellmont"
	},
	"chocolate_maker": {
		"name": "Chocolate Maker",
		"owned": true,
		"unlock_requirement": "Bellmont"
	},
	"cheese_processer": {
		"name": "Cheese Processer",
		"owned": true,
		"unlock_requirement": "Bellmont"
	},
	"butter_churn": {
		"name": "Butter Churn",
		"owned": true,
		"unlock_requirement": "Bellmont"
	},
	"grain_mill": {
		"name": "Grain Mill",
		"owned": true,
		"unlock_requirement": "Bellmont"
	},
#endregion
}
# Recipes and their unlock status.
var recipes: Dictionary = {
#region OATMEALS
	"plain_oatmeal": {
		"name": "Plain Oatmeal",
		"appliance": "cooking_pot",
		"unlocked": true,
		"ingredients": {
			"oats": 1,
			"milk": 1
		},
		"prep_time": 0,
		"sell_price": 0
	},
	"mixed_berry_oatmeal": {
		"name": "Mixed Berry Oatmeal",
		"appliance": "cooking_pot",
		"unlocked": true
	},
	"apple_cinnamon_oatmeal": {
		"name": "Apple Cinnamon Oatmeal",
		"appliance": "cooking_pot",
		"unlocked": true,
		"ingredients": {
			"oats": 1,
			"milk": 1,
			"apple": 1,
			"cinnamon": 1
		},
		"prep time": 0,
		"sell price": 0
	},
#endregion
#region SOUPS
	"mushroom_stew": {
		"name": "Mushroom Stew",
		"appliance": "cooking_pot",
		"unlocked": true,
		"ingredients": {
			"button mushroom": 1,
			"water": 1
		},
		"prep time": 0,
		"sell price": 0
	},
#endregion
#region BLENDED BEVERAGES
	"strawberry_banana_smoothie": {
		"name": "Strawberry Banana Smoothie",
		"appliance": "blender",
		"unlocked": true,
		"ingredients": {
			"strawberry": 1,
			"banana": 1,
			"water": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"vanilla_milkshake": {
		"name": "Vanilla Milkshake",
		"appliance": "blender",
		"unlocked": true,
		"ingredients": {
			"milk": 1,
			"vanilla syrup": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"chocolate_milkshake": {
		"name": "Chocolate Milkshake",
		"appliance": "blender",
		"unlocked": true,
		"ingredients": {
			"milk": 1,
			"chocolate": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"mixed_berry_smoothie": {
		"name": "Mixed Berry Smoothie",
		"appliance": "blender",
		"unlocked": true,
		"ingredients": {
			"water": 1,
			"blueberry": 1,
			"raspberry": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"mint_chocolate_milkshake": {
		"name": "Mint Chocolate Milkshake",
		"appliance": "blender",
		"unlocked": true,
		"ingredients": {
			"milk": 1,
			"mint": 1,
			"chocolate": 1
		},
		"prep time": 0,
		"sell price": 0
	},
#endregion
#region COFFEES
	"espresso": {
		"name": "Espresso",
		"appliance": "coffe_station",
		"unlocked": true,
		"ingredients": {
			"coffee_bean": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"americano": {
		"name": "Americano",
		"appliance": "coffee_station",
		"unlocked": true,
		"ingredients": {
			"coffee_bean": 1,
			"water": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"latte": {
		"name": "Latte",
		"appliance": "coffee_station",
		"unlocked": true,
		"ingredients": {
			"coffee_bean": 1,
			"milk": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"lavender_latte": {
		"name": "Lavender Latte",
		"appliance": "coffee_station",
		"unlocked": true,
		"ingredients": {
			"coffee_bean": 1,
			"milk": 1,
			"lavender_syrup": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"mocha": {
		"name": "Mocha",
		"appliance": "coffee_station",
		"unlocked": true,
		"ingredients": {
			"milk": 1,
			"chocolate": 1
		},
		"prep time": 0,
		"sell price": 0
	},

#endregion
#region SPECIALTY BEVERAGES
	"matcha_latte": {
		"name": "Matcha Latte",
		"appliance": "coffee_station",
		"unlocked": true,
		"ingredients": {
			"matcha_powder": 1,
			"milk": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"chai_latte": {
		"name": "Chai Latte",
		"appliance": "coffee_station",
		"unlocked": true,
		"ingredients": {
			"chai_spice_mix": 1,
			"milk": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"hot_chocolate": {
		"name": "Hot Chocolate",
		"appliance": "coffee_station",
		"unlocked": true,
		"ingredients": {
			"chocolate": 1,
			"milk": 1
		},
		"prep time": 0,
		"sell price": 0
	},
#endregion
#region TEAS
	"lavender_tea": {
		"name": "Lavender Tea",
		"appliance": "tea_station",
		"unlocked": true,
		"ingredients": {
			"lavender": 1,
			"water": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"chamomile_tea": {
		"name": "Chamomile Tea",
		"appliance": "tea_station",
		"unlocked": true,
		"ingredients": {
			"water": 1,
			"chamomile": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"moonpetal_tea": {
		"name": "Moonpetal Tea",
		"appliance": "tea_station",
		"unlocked": true,
		"ingredients": {
			"moonpetal": 1,
			"water": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"mint_tea": {
		"name": "Mint Tea",
		"appliance": "tea_station",
		"unlocked": true,
		"ingredients": {
			"mint": 1,
			"water": 1
		},
		"prep time": 0,
		"sell price": 0
	},
#endregion
#region SANDWICHES
	"grilled_cheese": {
		"name": "Grilled Cheese",
		"appliance": "bread_counter",
		"unlocked": true,
		"ingredients": {
			"cheese": 1,
			"bread": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"mushroom_sandwich": {
		"name": "Mushroom Sandwhich",
		"appliance": "bread_counter",
		"unlocked": true,
		"ingredients": {
			"bread": 1,
			"button_mushroom": 1,
			"butter": 1,
			"onion": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"garden_sandwich": {
		"name": "Garden Sandwich",
		"appliance": "bread_counter",
		"unlocked": true,
		"ingredients": {
			"bread": 1,
			"tomato": 1,
			"lettuce": 1
		},
		"prep time": 0,
		"sell price": 0
	},
#endregion
#region BAKED GOODS
	"banana_toast": {
		"name": "Banana Toast",
		"appliance": "bread_counter",
		"unlocked": true,
		"ingredients": {
			"banana_bread": 1,
			"butter": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"toast": {
		"name": "Toast",
		"appliance": "bread_counter",
		"unlocked": true,
		"ingredients": {
			"bread": 1,
			"butter": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"strawberry_jam_toast": {
		"name": "Strawberry Jam Toast",
		"appliance": "bread_counter",
		"unlocked": true,
		"ingredients": {
			"bread": 1,
			"strawberry": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"brownies": {
		"name": "Brownies",
		"appliance": "bakery_oven",
		"unlocked": true,
		"ingredients": {
			"chocolate": 1
		},
		"prep time": 0,
		"sell price": 0
	},
#endregion
#region SPICES
	"chai_spice_mix": {
		"name": "Chai Spice Mix",
		"appliance": "pestle_mortar",
		"unlocked": true,
		"ingredients": {
			"cinnamon": 1,
			"ginger": 1,
			"cardamon": 1
		},
		"prep time": 0,
		"sell price": 0
	},
#endregion
#region PRESERVES
	"vanilla_syrup": {
		"name": "Vanilla Syrup",
		"appliance": "preserving_station",
		"unlocked": true,
		"ingredients": {
			"vanilla": 1,
			"sugar": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"strawberry_jam": {
		"name": "Strawberry Jam",
		"appliance": "preserving_station",
		"unlocked": true,
		"ingredients": {
			"strawberry": 1,
			"sugar": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"lavender_syrup": {
		"name": "Lavender Syrup",
		"appliance": "preserving_station",
		"unlocked": true,
		"ingredients": {
			"lavender": 1,
			"sugar": 1,
			"water": 1
		},
		"prep time": 0,
		"sell price": 0
	},
#endregion
#region SWEETENERS
	"chocolate": {
		"name": "Chocolate",
		"appliance": "chocolate_maker",
		"unlocked": true,
		"ingredients": {
			"cocoa_bean": 1
		},
		"prep time": 0,
		"sell price": 0
	},
#endregion
#region DAIRY & EGGS
	"cheese": {
		"name": "Cheese",
		"appliance": "cheese_processer",
		"unlocked": true,
		"ingredients": {
			"milk": 1
		},
		"prep time": 0,
		"sell price": 0
	},
	"butter": {
		"name": "Butter",
		"appliance": "butter_churn",
		"unlocked": true,
		"ingredients": {
			"milk": 1
		},
		"prep time": 0,
		"sell price": 0
	},
#endregion
#region GRAINS
	"flour": {
		"name": "Flour",
		"appliance": "grain_mill",
		"unlocked": true,
		"ingredients": {
			"wheat": 1
		},
		"prep time": 0,
		"sell price": 0
	},
#endregion
}


func get_unlocked_recipes(
	appliance_id: String
) -> Array[Dictionary]:
	var results: Array[Dictionary] = []

	for recipe_id in recipes:
		var recipe: Dictionary = recipes[recipe_id]

		if recipe["appliance"] == appliance_id:
			if recipe["unlocked"]:
				results.append({
					"id": recipe_id,
					"name": recipe["name"]
				})

	return results


func unlock_recipe(recipe_id: String) -> void:
	if recipes.has(recipe_id):
		recipes[recipe_id]["unlocked"] = true
