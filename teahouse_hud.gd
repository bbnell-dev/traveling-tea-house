extends CanvasLayer

# ==================================================
# TRAVELING TEA HOUSE - EDIT MODE HUD
# Handles menus, storage, categories, and style choices.
# Physical placement is handled by DecorationManager.
# ==================================================

const ApplianceCatalog = preload(
    "res://teahouse/appliances/appliance_catalog.gd"
)

# EDIT MODE BUTTON
@onready var edit_button: Button = $HUDRoot/EditModeButton

# TEA HOUSE STORAGE
@onready var storage_button: Button = $HUDRoot/StorageButton
@onready var storage_panel: PanelContainer = $HUDRoot/StoragePanel

@onready var storage_title: Label = $HUDRoot/StoragePanel/MarginContainer/VBoxContainer/StorageTitle

# STORAGE CATEGORIES
@onready var category_tabs: TabBar = $HUDRoot/StoragePanel/MarginContainer/VBoxContainer/CategoryTabs

@onready var appliances_list: GridContainer = $HUDRoot/StoragePanel/MarginContainer/VBoxContainer/AppliancesList

@onready var items_list: GridContainer = $HUDRoot/StoragePanel/MarginContainer/VBoxContainer/ItemsList

# APPLIANCE STYLE PICKER
@onready var style_panel: VBoxContainer = $HUDRoot/StoragePanel/MarginContainer/VBoxContainer/StylePanel

@onready var style_title: Label = $HUDRoot/StoragePanel/MarginContainer/VBoxContainer/StylePanel/StyleTitle

@onready var style_options: GridContainer = $HUDRoot/StoragePanel/MarginContainer/VBoxContainer/StylePanel/StyleOptions

@onready var back_button: Button = $HUDRoot/StoragePanel/MarginContainer/VBoxContainer/StylePanel/BackButton

# WORLD REFERENCES
@onready var placement_grid: Node2D = get_parent().get_node_or_null("PlacementGrid")

@onready var decoration_manager: Node2D = get_parent().get_node_or_null("DecorationManager")

# HUD STATE
var is_editing: bool = false


# ==================================================
# INITIAL SETUP
# ==================================================

func _ready() -> void:

	# Start in normal gameplay mode.
	storage_button.hide()
	storage_panel.hide()
	style_panel.hide()

	edit_button.text = "Edit Mode"

	if placement_grid:
		placement_grid.hide_grid()

	# Connect buttons.
	edit_button.pressed.connect(_on_edit_button_pressed)
	storage_button.pressed.connect(_on_storage_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

	# Connect category tabs.
	category_tabs.tab_changed.connect(_on_category_changed)

	# Two style buttons per row.
	style_options.columns = 2

	# Start on Appliances.
	category_tabs.current_tab = 0
	_on_category_changed(0)

	# Populate the appliance catalog.
	_populate_appliances()


# ==================================================
# EDIT MODE
# ==================================================

func _on_edit_button_pressed() -> void:

	is_editing = not is_editing

	if is_editing:
		_enter_edit_mode()
	else:
		_exit_edit_mode()


func _enter_edit_mode() -> void:

	edit_button.text = "Done"
	storage_button.show()

	if placement_grid:
		placement_grid.show_grid()

	if decoration_manager and decoration_manager.has_method("set_edit_mode"):
		decoration_manager.call("set_edit_mode", true)


func _exit_edit_mode() -> void:

	edit_button.text = "Edit Mode"

	storage_button.hide()
	storage_panel.hide()
	style_panel.hide()

	if placement_grid:
		placement_grid.hide_grid()

	if decoration_manager:
		if decoration_manager.has_method("cancel_placement"):
			decoration_manager.call("cancel_placement")

		if decoration_manager.has_method("set_edit_mode"):
			decoration_manager.call("set_edit_mode", false)


# ==================================================
# TEA HOUSE STORAGE
# ==================================================

func _on_storage_button_pressed() -> void:

	if not is_editing:
		return

	if storage_panel.visible:
		storage_panel.hide()
		return

	_show_storage_catalog()
	_populate_appliances()
	storage_panel.show()


func _show_storage_catalog() -> void:

	storage_title.text = "Teahouse Inventory"

	style_panel.hide()
	category_tabs.show()

	_on_category_changed(category_tabs.current_tab)


# ==================================================
# STORAGE TABS
# ==================================================

func _on_category_changed(tab_index: int) -> void:

	if style_panel.visible:
		return

	appliances_list.visible = (tab_index == 0)
	items_list.visible = (tab_index == 1)


# ==================================================
# APPLIANCE CATALOG
# ==================================================

func _populate_appliances() -> void:

	# Clear previous buttons.
	for child in appliances_list.get_children():
		appliances_list.remove_child(child)
		child.queue_free()

	# Create an entry for each available appliance.
	for appliance_id in ApplianceCatalog.APPLIANCES:

		var appliance_name: String = (
			ApplianceCatalog.APPLIANCES[appliance_id]
		)

		var appliance_button := Button.new()

		appliance_button.text = appliance_name
		appliance_button.custom_minimum_size = Vector2(110, 110)
		appliance_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		appliance_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

		# Load first visual as thumbnail.
		var visuals: Array = ApplianceCatalog.APPLIANCE_VISUALS.get(
			appliance_id, []
		)

		if not visuals.is_empty():

			var texture_path: String = visuals[0]

			if ResourceLoader.exists(texture_path):

				var texture: Texture2D = load(texture_path)

				if texture:
					appliance_button.icon = texture
					appliance_button.expand_icon = true

		# Check whether this appliance is already placed.
		var already_placed: bool = false

		if decoration_manager and decoration_manager.has_method("is_appliance_placed"):
			already_placed = bool(
				decoration_manager.call("is_appliance_placed", appliance_id)
			)

		if already_placed:

			appliance_button.disabled = true
			appliance_button.modulate = Color(0.5, 0.5, 0.5, 1.0)

		else:

			appliance_button.pressed.connect(
				_on_appliance_selected.bind(appliance_id)
			)

		appliances_list.add_child(appliance_button)


# ==================================================
# OPEN APPLIANCE STYLE PICKER
# ==================================================

func _on_appliance_selected(appliance_id: String) -> void:

	if not is_editing:
		return

	var appliance_name: String = ApplianceCatalog.APPLIANCES.get(
		appliance_id, appliance_id
	)

	style_title.text = "Choose " + appliance_name + " Style"

	# Clear old style buttons.
	for child in style_options.get_children():
		style_options.remove_child(child)
		child.queue_free()

	var visuals: Array = ApplianceCatalog.APPLIANCE_VISUALS.get(
		appliance_id, []
	)

	# Create buttons for the four artwork choices.
	for i in range(visuals.size()):

		var texture_path: String = visuals[i]

		if not ResourceLoader.exists(texture_path):
			push_warning("Missing appliance image: " + texture_path)
			continue

		var texture: Texture2D = load(texture_path)

		if texture == null:
			continue

		var style_button := Button.new()

		style_button.icon = texture
		style_button.expand_icon = true
		style_button.custom_minimum_size = Vector2(130, 130)

		style_button.pressed.connect(
			_on_style_selected.bind(appliance_id, i)
		)

		style_options.add_child(style_button)

	# Switch to the style picker.
	category_tabs.hide()
	appliances_list.hide()
	items_list.hide()

	style_panel.show()


# ==================================================
# CHOOSE AN APPLIANCE STYLE
# ==================================================

func _on_style_selected(
	appliance_id: String,
	style_index: int
) -> void:

	if not is_editing:
		return

	if decoration_manager == null:
		push_warning("DecorationManager was not found.")
		return

	if not decoration_manager.has_method("start_placement"):
		push_warning("DecorationManager placement is not connected yet.")
		return

	# Hand placement responsibility to the manager.
	decoration_manager.call(
		"start_placement",
		appliance_id,
		style_index
	)

	# Close storage so the player can place the appliance.
	storage_panel.hide()


# ==================================================
# RETURN TO STORAGE CATALOG
# ==================================================

func _on_back_button_pressed() -> void:

	_show_storage_catalog()


# ==================================================
# REFRESH AFTER PLACEMENT OR STORAGE CHANGES
# ==================================================

func refresh_storage() -> void:

	_populate_appliances()
