extends CanvasLayer

#region ONREADY VARS

@onready var hotbar: HBoxContainer = $Hotbar
@onready var backpack_panel: PanelContainer = $BackpackPanel
@onready var backpack_grid: GridContainer = $BackpackPanel/MarginContainer/VBoxContainer/BackpackGrid
@onready var backpack_title: Label = $BackpackPanel/MarginContainer/VBoxContainer/BackpackTitle

#endregion

var hotbar_buttons: Array[Button] = []
var backpack_buttons: Array[Button] = []

#region READY FUNC

func _ready() -> void:
	_setup_hotbar()
	_setup_backpack()
	backpack_panel.hide()
	
	
	InventoryData.inventory_changed.connect(_refresh_inventory_display)
	_refresh_inventory_display()

#endregion

#region HOTBAR SETUP
func _setup_hotbar() -> void:
	for i in range(InventoryData.HOTBAR_SIZE):
		var slot := Button.new()
		slot.text = str(i + 1)
		slot.custom_minimum_size = Vector2(48, 48)
		slot.focus_mode = Control.FOCUS_NONE
	
		hotbar.add_child(slot)
		hotbar_buttons.append(slot)
		slot.set_drag_forwarding(
			_drag_slot.bind("hotbar", i),
			_can_drop_slot.bind("hotbar", i),
			_drop_slot.bind("hotbar", i)
		)
	
		slot.pressed.connect(
			_select_hotbar.bind(i)
		)
		
	_update_hotbar_selection()
	
#endregion

#region BACKPACK SETUP
func _setup_backpack() -> void:
	backpack_title.text = "Backpack"
	backpack_grid.columns = 5
	
	for i in range(InventoryData.BACKPACK_SIZE):
		var slot := Button.new()
		slot.custom_minimum_size = Vector2(52, 52)
		slot.focus_mode = Control.FOCUS_NONE
		
		backpack_grid.add_child(slot)
		backpack_buttons.append(slot)
		slot.set_drag_forwarding(
			_drag_slot.bind("backpack", i),
			_can_drop_slot.bind("backpack", i),
			_drop_slot.bind("backpack", i)
		)
		
#endregion

#region FUNCTIONS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if event is InputEventKey and event.echo:
			return
			
		backpack_panel.visible = not backpack_panel.visible
		get_viewport().set_input_as_handled()
		return
		
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode >= KEY_1 and event.keycode <= KEY_8:
				_select_hotbar(event.keycode - KEY_1)
				get_viewport().set_input_as_handled()
				
func _select_hotbar(index: int) -> void:
	InventoryData.selected_hotbar_slot = index
	_update_hotbar_selection()
	
func _update_hotbar_selection() -> void:
	for i in range(hotbar_buttons.size()):
		if i == InventoryData.selected_hotbar_slot:
			hotbar_buttons[i].modulate = Color(
				1.0, 0.85, 0.5
			)
		else:
			hotbar_buttons[i].modulate = Color.WHITE

#endregion

#region INVENTORY DISPLAY

func _refresh_inventory_display() -> void:
	for i in range(InventoryData.HOTBAR_SIZE):
		var slot = InventoryData.hotbar[i]
		var button = hotbar_buttons[i]

		if slot == null:
			button.text = str(i + 1)
		else:
			var item_name: String = str(slot["id"]).capitalize()
			var quantity: int = slot["quantity"]

			button.text = "%d\n%s x%d" % [
				i + 1,
				item_name,
				quantity
			]
# Updates baackpack slots
	for i in range(InventoryData.BACKPACK_SIZE):
		var slot = InventoryData.backpack[i]
		var button = backpack_buttons[i]
		
		if slot == null:
			button.text = ""
		else:
			var item_name: String = str(slot["id"]).capitalize()
			var quantity: int = int(slot["quantity"])
			
			button.text = "%s x%d" % [item_name, quantity]

#endregion

#region DRAG AND DROP INVENTORY
func _get_inventory_array(inventory_name: String) -> Array:
	if inventory_name == "hotbar":
		return InventoryData.hotbar
		
	if inventory_name == "backpack":
		return InventoryData.backpack
		
	return []
	
func _drag_slot(
	_position: Vector2,
	inventory_name: String,
	index: int
) -> Variant:
	var inventory := _get_inventory_array(inventory_name)
	
	if index < 0 or index >= inventory.size():
		return null
		
	var item = inventory[index]
	
# Empty slots cannot be dragged
	if item == null:
		return null
		
# Show item underneath mouse
	var preview := Label.new()
	preview.text = "%s x%d" % [
		str(item["id"]).capitalize(),
		int(item["quantity"])
	]
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var button: Button
	
	if inventory_name == "hotbar":
		button = hotbar_buttons[index]
	else:
		button = backpack_buttons[index]
	
	button.set_drag_preview(preview)
	
	return {
		"type": "inventory_slot",
		"inventory": inventory_name,
		"index": index
	}

func _can_drop_slot(
	_position: Vector2,
	data: Variant,
	inventory_name: String,
	index: int
) -> bool:
	if not data is Dictionary:
		return false
		
	if data.get("type", "") != "inventory_slot":
		return false
		
	var source := _get_inventory_array(
		str(data["inventory"])
	)
	
	var destination := _get_inventory_array(inventory_name)
	
	return (
		int(data["index"]) >= 0
		and int(data["index"]) < source.size()
		and index >= 0
		and index < destination.size()
	)
	
func _drop_slot(
	_position: Vector2,
	data: Variant,
	inventory_name: String,
	index: int
) -> void:
	if not _can_drop_slot(
		_position, data, inventory_name, index
	):
		return
		
	InventoryData.swap_slots(
		str(data["inventory"]),
		int(data["index"]),
		inventory_name,
		index
	)
	#endregion
	
