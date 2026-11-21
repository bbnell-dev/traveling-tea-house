extends Node2D

#region GRID SETTINGS

@export var cell_size: int = 16

# Temporary rectangular grid area.
# Adjust this to match the actual Tea House floor.
@export var grid_origin: Vector2 = Vector2.ZERO
@export var grid_size: Vector2 = Vector2(704, 765)

@export var line_color: Color = Color(
	1.0, 0.96, 0.84, 0.35
)

#endregion


#region INITIALIZATION

func _ready() -> void:
	visible = true

#endregion


#region DRAW GRID

func _draw() -> void:
	var columns := int(floor(grid_size.x / cell_size))
	var rows := int(floor(grid_size.y / cell_size))

	for x in range(columns + 1):
		var x_pos := grid_origin.x + x * cell_size

		draw_line(
			Vector2(x_pos, grid_origin.y),
			Vector2(x_pos, grid_origin.y + rows * cell_size),
			line_color,
			1.0,
			false
		)

	for y in range(rows + 1):
		var y_pos := grid_origin.y + y * cell_size

		draw_line(
			Vector2(grid_origin.x, y_pos),
			Vector2(grid_origin.x + columns * cell_size, y_pos),
			line_color,
			1.0,
			false
		)

#endregion


#region EDIT MODE

func show_grid() -> void:
	visible = true


func hide_grid() -> void:
	visible = false

#endregion
