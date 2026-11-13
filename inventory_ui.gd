extends CanvasLayer

@onready var hotbar: HBoxContainer = $Hotbar
@onready var backpack_panel: PanelContainer = $BackpackPanel
@onready var backpack_grid: GridContainer = $BackpackPanel/MarginContainer/VBoxContainer/BackpackGrid
@onready var backpack_title: Label = $BackpackPanel/MarginContainer/VBoxContainer/BackpackTitle

var hotbar_buttons: Array[Button] = []

func _ready() -> void:
	_setup_hotbar()
	_setup_backpack()
	backpack_panel.hide()
	
func _setup_hotbar() -> void:
	for i in range(InventoryData.HOTBAR_SIZE):
		var slot := Button.new()
		slot.text = str(i + 1)
		slot.custom_minimum_size = Vector2(48, 48)
		slot.focus_mode = Control.FOCUS_NONE
	
		hotbar.add_child(slot)
		hotbar_buttons.append(slot)
	
		slot.pressed.connect(
			_select_hotbar.bind(i)
		)
		
	_update_hotbar_selection()
	
func _setup_backpack() -> void:
	backpack_title.text = "Backpack"
	backpack_grid.columns = 5
	
	for i in range(InventoryData.BACKPACK_SIZE):
		var slot := Button.new()
		slot.custom_minimum_size = Vector2(52, 52)
		slot.focus_mode = Control.FOCUS_NONE
		backpack_grid.add_child(slot)
		
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
