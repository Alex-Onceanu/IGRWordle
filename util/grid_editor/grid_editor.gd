@tool
extends Node
class_name GridEditor

@export_category("Grid Parameters")
@export_range(1, 100) var grid_size_x: int = 5:
	set(value):
		grid_size_x = value
		_update_grid_container()
@export_range(1, 100) var grid_size_y: int = 5:
	set(value):
		grid_size_y = value
		_update_grid_container()
@export var grid_resource: GridResource = GridResource.new():
	set(value):
		grid_resource = value
		_build_grid_from_resource()
@export var default_save_path: String = "res://resources/grid/"
@export_category("Nodes")
@export var grid_container: GridContainer
@export var editor_cell_scene: PackedScene
var cell_layout: Dictionary[Vector2i, int]
var padding: int = 10 
static var grid_resource_count: int = 0


func _ready() -> void:
	_build_grid_from_resource()
	_update_grid_container()


func _update_grid_container() -> void:
	if grid_container == null:
		return
	grid_container.columns = grid_size_x
	var cells = grid_container.get_children()
	for cell in cells:
		cell.queue_free()
	for i in range(grid_size_x * grid_size_y):
		var cell_node = editor_cell_scene.instantiate()
		cell_node.cell_position = Vector2i(i / grid_size_x, i % grid_size_x)
		if cell_layout.has(cell_node.cell_position):
			cell_node.activated = true
		grid_container.add_child(cell_node)


func _build_grid_from_resource() -> void:
	if grid_resource == null:
		return
	grid_size_x = grid_resource.grid_size.x
	grid_size_y = grid_resource.grid_size.y
	for i in grid_resource.cell_layout:
		cell_layout.get_or_add(i, 0)
	

func _change_cell_layout(cell_position: Vector2i, adding: bool):
	if adding:
		cell_layout.get_or_add(cell_position, 0)
	else:
		cell_layout.erase(cell_position)
	

## This function takes the grid that is currently being worked on in the editor and makes so that the
## limits of the grid are the cell with `min(x)`, the one with `min(y)`, the one with `max(x)`, and 
## the one with `max(y)`.
func _save_normalized_grid() -> void:
	var sorted_keys = cell_layout.keys()
	sorted_keys.sort_custom(func(x, y): return x.x < y.x)
	var min_x = sorted_keys[0].x
	var max_x = sorted_keys[-1].x
	sorted_keys.sort_custom(func(x, y): return x.y < y.y)
	var min_y = sorted_keys[0].y
	var max_y = sorted_keys[-1].y
	print_rich("[color=orange]final bounding coordinates: [/color](", min_x, ", ", min_y, "), (", max_x, ", ", max_y, ")")
	grid_resource.grid_size.x = abs(max_x - min_x + 1)
	grid_resource.grid_size.y = abs(max_y - min_y + 1)
	print_rich("[color=aquamarine]the grid will be reduced to ", grid_resource.grid_size.x, ", ", grid_resource.grid_size.y)
	var normalized_keys = cell_layout.keys()
	for i in range(normalized_keys.size()):
		normalized_keys[i] -= Vector2i(min_x, min_y)
	grid_resource.cell_layout.clear()
	for key in normalized_keys:
		grid_resource.cell_layout.get_or_add(key, 0)
	

func _on_editor_cell_pressed(cell: EditorCell) -> void:
	cell.activated = !cell.activated
	_change_cell_layout(cell.cell_position, cell.activated)


func _on_save_pressed() -> void:
	grid_resource.cell_layout = cell_layout
	_save_normalized_grid()
	if not grid_resource.resource_path.ends_with(".tres"):
		var date = Time.get_date_dict_from_system();
		var time = Time.get_time_dict_from_system()
		var year: int = date.year
		var month: int = date.month
		var day: int = date.day
		var hour: int = time.hour
		var minute: int = time.minute
		var second: int = time.second
		grid_resource.take_over_path(default_save_path + "grid_" + str(year) + str(month) + str(day) + str(hour) + str(minute) + str(second) + ".tres")
	ResourceSaver.save(grid_resource, grid_resource.resource_path)
