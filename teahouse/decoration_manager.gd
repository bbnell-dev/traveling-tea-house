
extends Node2D

# ==========================================
# TEA HOUSE DECORATION MANAGER
# ==========================================

const ApplianceCatalog = preload(
    "res://teahouse/appliances/appliance_catalog.gd"
)

# One complete floor tile, in world pixels.
@export_range(8, 128, 1) var floor_tile_size: int = 32

# 0 = Full Tile, 1 = Half Tile
@export_enum("Full Tile", "Half Tile") var snap_mode: int = 0

@export_range(0.1, 1.0, 0.05) var preview_opacity: float = 0.7

@onready var placement_grid: Node2D = get_parent().get_node_or_null("PlacementGrid")
@onready var placed_appliances: Node2D = get_parent().get_node_or_null("PlacedAppliances")
@onready var tea_house_hud: CanvasLayer = get_parent().get_node_or_null("TeahouseHUD")

@export_range(0.5, 4.0, 0.1)
var appliance_visual_scale: float = 1.5

var is_editing: bool = false

var pending_appliance_id: String = ""
var pending_style_index: int = -1

var placed_appliance_ids: Dictionary = {}
var occupied_cells: Dictionary = {}

var preview_sprite: Sprite2D
var preview_footprint: Polygon2D


# ==========================================
# EDIT MODE
# ==========================================

func set_edit_mode(enabled: bool) -> void:
	is_editing = enabled

	if not enabled:
		cancel_placement()


func is_appliance_placed(appliance_id: String) -> bool:
	return placed_appliance_ids.has(appliance_id)


func set_snap_mode(use_half_tiles: bool) -> void:
	snap_mode = 1 if use_half_tiles else 0


# ==========================================
# APPLIANCE FOOTPRINT
# ==========================================

func _get_footprint(style_index: int) -> Vector2i:
	# Front/back: two tiles horizontally.
	if style_index == 0 or style_index == 1:
		return Vector2i(2, 1)

	# Left/right: two tiles vertically.
	return Vector2i(1, 2)


# ==========================================
# START PLACEMENT
# ==========================================

func start_placement(
	appliance_id: String,
	style_index: int
) -> void:

	if not is_editing:
		return

	if is_appliance_placed(appliance_id):
		return

	var texture: Texture2D = _get_texture(
		appliance_id,
		style_index
	)

	if texture == null:
		return

	cancel_placement()

	pending_appliance_id = appliance_id
	pending_style_index = style_index

	# Create the artwork preview.
	preview_sprite = Sprite2D.new()
	preview_sprite.name = "AppliancePreview"
	preview_sprite.z_index = 20

	_configure_sprite(
		preview_sprite,
		texture,
		style_index
	)

	preview_sprite.modulate.a = preview_opacity
	placed_appliances.add_child(preview_sprite)

	# Create the two-tile placement highlight.
	preview_footprint = Polygon2D.new()
	preview_footprint.name = "PlacementHighlight"
	preview_footprint.z_index = 19

	placed_appliances.add_child(preview_footprint)

	_update_preview()


# ==========================================
# LOAD APPLIANCE ARTWORK
# ==========================================

func _get_texture(
	appliance_id: String,
	style_index: int
) -> Texture2D:

	var visuals: Array = ApplianceCatalog.APPLIANCE_VISUALS.get(
		appliance_id, []
	)

	if style_index < 0 or style_index >= visuals.size():
		return null

	var path: String = visuals[style_index]

	if not ResourceLoader.exists(path):
		push_warning("Missing appliance image: " + path)
		return null

	var texture: Texture2D = load(path)
	return texture


# ==========================================
# PROPORTIONAL SPRITE SIZING
# ==========================================

func _configure_sprite(
	sprite: Sprite2D,
	texture: Texture2D,
	style_index: int
) -> void:

	sprite.texture = texture
	sprite.centered = true

	sprite.texture_filter = (
		CanvasItem.TEXTURE_FILTER_NEAREST
	)

	# Find visible artwork, excluding transparent padding.
	var image: Image = texture.get_image()
	var used_rect := Rect2i(
		Vector2i.ZERO,
		Vector2i(texture.get_size())
	)

	if image != null:
		var visible_rect: Rect2i = image.get_used_rect()

		if visible_rect.size.x > 0 and visible_rect.size.y > 0:
			used_rect = visible_rect

	# Display only the artwork's visible region.
	sprite.region_enabled = true
	sprite.region_rect = Rect2(used_rect)

	var footprint: Vector2i = _get_footprint(style_index)

	var target_size := Vector2(
		footprint
	) * float(floor_tile_size)

	var artwork_size := Vector2(used_rect.size)

	# Use one scale value for both axes.
	# This prevents stretched artwork.
	var uniform_scale: float

	if style_index < 2:
	# Front / Back: fit the width of two tiles
		uniform_scale = target_size.x / maxf(artwork_size.x, 1.0)
	else:
	# Left / Right: fit the length of two tiles
		uniform_scale = target_size.y / maxf(artwork_size.y, 1.0)

	sprite.scale = Vector2.ONE * uniform_scale
	sprite.offset = Vector2(
	0,
	-float(used_rect.size.y) / 2.0
)

# ==========================================
# GET SNAPPED PLACEMENT
# ==========================================

func _get_hover_placement() -> Dictionary:

	if pending_appliance_id.is_empty():
		return {}

	if floor_tile_size < 2:
		return {}

	var grid_origin: Vector2 = placement_grid.get(
        "grid_origin"
	)

	var grid_size: Vector2 = placement_grid.get(
        "grid_size"
	)

	var mouse_pos: Vector2 = (
		placement_grid.get_local_mouse_position()
	)

	var half_cell: float = float(floor_tile_size) / 2.0

	var snap_step: float = float(floor_tile_size)

	if snap_mode == 1:
		snap_step = half_cell

	var snap_x: int = floori(
		(mouse_pos.x - grid_origin.x) / snap_step
	)

	var snap_y: int = floori(
		(mouse_pos.y - grid_origin.y) / snap_step
	)

	var step_cells: int = 2

	if snap_mode == 1:
		step_cells = 1

	var start_cell := Vector2i(
		snap_x * step_cells,
		snap_y * step_cells
	)

	# Track every occupied half-tile cell.
	var footprint: Vector2i = (
		_get_footprint(pending_style_index) * 2
	)

	var top_left: Vector2 = grid_origin + (
		Vector2(start_cell) * half_cell
	)

	var footprint_size: Vector2 = (
		Vector2(footprint) * half_cell
	)

	var center: Vector2 = (
		top_left + footprint_size / 2.0
	)

	var cells: Array[Vector2i] = []

	for x in range(footprint.x):
		for y in range(footprint.y):
			cells.append(
				start_cell + Vector2i(x, y)
			)

	return {
		"start_cell": start_cell,
		"top_left": top_left,
		"center": center,
		"size": footprint_size,
		"cells": cells,
		"bounds": Rect2(grid_origin, grid_size)
	}


# ==========================================
# CHECK PLACEMENT VALIDITY
# ==========================================

func _is_valid_placement(data: Dictionary) -> bool:

	if data.is_empty():
		return false

	var start_cell: Vector2i = data["start_cell"]

	if start_cell.x < 0 or start_cell.y < 0:
		return false

	var footprint_rect := Rect2(
		data["top_left"],
		data["size"]
	)

	var bounds: Rect2 = data["bounds"]

	# Both floor tiles must fit inside the grid.
	if not bounds.encloses(footprint_rect):
		return false

	# No overlap with another placed appliance.
	for cell in data["cells"]:
		if occupied_cells.has(cell):
			return false

	return true


# ==========================================
# LIVE PLACEMENT PREVIEW
# ==========================================

func _process(_delta: float) -> void:

	if not is_editing:
		return

	if pending_appliance_id.is_empty():
		return

	_update_preview()


func _update_preview() -> void:

	if not is_instance_valid(preview_sprite):
		return

	if not is_instance_valid(preview_footprint):
		return

	var data: Dictionary = _get_hover_placement()

	if data.is_empty():
		return

	var world_center: Vector2 = placement_grid.to_global(data["top_left"] + Vector2(data["size"].x / 2.0, data["size"].y))


	# Preview and final placement share this position.
	preview_sprite.global_position = world_center

	var size: Vector2 = data["size"]

	preview_footprint.polygon = PackedVector2Array([
		Vector2.ZERO,
		Vector2(size.x, 0),
		Vector2(size.x, size.y),
		Vector2(0, size.y)
	])

	preview_footprint.global_position = (
		placement_grid.to_global(data["top_left"])
	)

	if _is_valid_placement(data):
		preview_footprint.color = Color(
			0.25, 0.9, 0.4, 0.35
		)
	else:
		preview_footprint.color = Color(
			0.95, 0.2, 0.2, 0.45
		)


# ==========================================
# MOUSE INPUT
# ==========================================

func _unhandled_input(event: InputEvent) -> void:

	if not is_editing:
		return

	if pending_appliance_id.is_empty():
		return

	if event is InputEventMouseButton:

		if not event.pressed:
			return

		if event.button_index == MOUSE_BUTTON_LEFT:
			_place_selected_appliance()
			get_viewport().set_input_as_handled()

		elif event.button_index == MOUSE_BUTTON_RIGHT:
			cancel_placement()
			get_viewport().set_input_as_handled()


# ==========================================
# PLACE THE APPLIANCE
# ==========================================

func _place_selected_appliance() -> void:

	if pending_appliance_id.is_empty():
		return

	if is_appliance_placed(pending_appliance_id):
		return

	var data: Dictionary = _get_hover_placement()

	if not _is_valid_placement(data):
		print("Invalid placement location.")
		return

	var texture: Texture2D = _get_texture(
		pending_appliance_id,
		pending_style_index
	)

	if texture == null:
		return

	var appliance_id: String = pending_appliance_id
	var style_index: int = pending_style_index

	# Create the finished appliance.
	var appliance_sprite := Sprite2D.new()

	appliance_sprite.name = appliance_id
	appliance_sprite.z_index = 5

	_configure_sprite(
		appliance_sprite,
		texture,
		style_index
	)

	placed_appliances.add_child(appliance_sprite)

	# Exact same snapped center as the preview.
	appliance_sprite.global_position = placement_grid.to_global(
		data["top_left"] + Vector2(
			data["size"].x / 2.0,
			data["size"].y
		)
	)
	# Store data for future Move / Store controls.
	appliance_sprite.set_meta(
		"appliance_id",
		appliance_id
	)

	appliance_sprite.set_meta(
		"style_index",
		style_index
	)

	appliance_sprite.set_meta(
		"start_cell",
		data["start_cell"]
	)

	# Reserve the occupied grid cells.
	for cell in data["cells"]:
		occupied_cells[cell] = appliance_id

	# Only one of each appliance is allowed.
	placed_appliance_ids[appliance_id] = true

	# Remove the moving preview.
	cancel_placement()

	# Gray out the appliance in storage.
	if tea_house_hud.has_method("refresh_storage"):
		tea_house_hud.call("refresh_storage")

	print("Placed appliance: ", appliance_id)


# ==========================================
# CANCEL / CLEAN UP PREVIEW
# ==========================================

func cancel_placement() -> void:

	pending_appliance_id = ""
	pending_style_index = -1

	if is_instance_valid(preview_sprite):
		preview_sprite.hide()
		preview_sprite.queue_free()

	if is_instance_valid(preview_footprint):
		preview_footprint.hide()
		preview_footprint.queue_free()

	preview_sprite = null
	preview_footprint = null
