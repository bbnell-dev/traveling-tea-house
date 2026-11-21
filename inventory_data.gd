extends Node

#region INVENTORY SETTINGS

const HOTBAR_SIZE: int = 8
const BACKPACK_SIZE: int = 20
const MAX_STACK: int = 99

signal inventory_changed

var hotbar: Array = []
var backpack: Array = []

var selected_hotbar_slot: int = 0

#endregion


#region SETUP

func _ready() -> void:
	hotbar.resize(HOTBAR_SIZE)
	backpack.resize(BACKPACK_SIZE)

	# Temporary ingredient test
	add_item("oats", 5)
	add_item("milk", 3)

	print("Oats: ", get_item_count("oats"))
	print("Milk: ", get_item_count("milk"))
	print("Can make oatmeal: ", has_ingredients({
		"oats": 1,
		"milk": 1
	}))

#endregion


#region ADD ITEMS

func add_item(item_id: String, amount: int = 1) -> int:
	if amount <= 0:
		return 0

	var remaining: int = amount

	# Fill existing stacks.
	for inventory in [hotbar, backpack]:
		for i in range(inventory.size()):
			var slot = inventory[i]
			
			if slot == null:
				continue

			if slot["id"] == item_id:
				var space: int = MAX_STACK - slot["quantity"]
				var added: int = min(space, remaining)
				
				slot["quantity"] += added
				remaining -= added
				
				if remaining == 0:
					inventory_changed.emit()
					return 0

	# Fill empty slots.
	for inventory in [hotbar, backpack]:
		for i in range(inventory.size()):
			if inventory[i] == null:
				var added: int = min(MAX_STACK, remaining)

				inventory[i] = {
					"id": item_id,
					"quantity": added
				}

				remaining -= added

				if remaining == 0:
					inventory_changed.emit()
					return 0

	inventory_changed.emit()
	return remaining

#endregion


#region COUNT ITEMS

func get_item_count(item_id: String) -> int:
	var total: int = 0

	for inventory in [hotbar, backpack]:
		for slot in inventory:
			if slot != null and slot["id"] == item_id:
				total += slot["quantity"]

	return total

#endregion


#region CHECK INGREDIENTS

func has_ingredients(required: Dictionary) -> bool:
	for item_id in required:
		if get_item_count(item_id) < int(required[item_id]):
			return false

	return true

#endregion


#region REMOVE ITEMS

func remove_item(item_id: String, amount: int = 1) -> bool:
	if amount <= 0:
		return false

	if get_item_count(item_id) < amount:
		return false

	var remaining: int = amount

	for inventory in [hotbar, backpack]:
		for i in range(inventory.size()):
			var slot = inventory[i]

			if slot == null or slot["id"] != item_id:
				continue

			var removed: int = min(slot["quantity"], remaining)

			slot["quantity"] -= removed
			remaining -= removed

			if slot["quantity"] == 0:
				inventory[i] = null

			if remaining == 0:
				inventory_changed.emit()
				return true

	return false

#endregion


#region MOVE INVENTORY ITEMS

func swap_slots(
	from_inventory: String,
	from_index: int,
	to_inventory: String,
	to_index: int
) -> void:
	var source: Array
	var destination: Array

	if from_inventory == "hotbar":
		source = hotbar
	elif from_inventory == "backpack":
		source = backpack
	else:
		return

	if to_inventory == "hotbar":
		destination = hotbar
	elif to_inventory == "backpack":
		destination = backpack
	else:
		return

	if from_index < 0 or from_index >= source.size():
		return

	if to_index < 0 or to_index >= destination.size():
		return

	var temporary = source[from_index]

	source[from_index] = destination[to_index]
	destination[to_index] = temporary

	inventory_changed.emit()

#endregion
