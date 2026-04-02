extends Control
class_name Grid

# TODO change Grid to WordGrid so that is less confusing (and change references to it to
#       word_grid everywhere in the project)
# TODO add enum with the cell states as well as a function to get the state of a cell and one to set it
#region Variables
# enum State {
# 	NORMAL,
# 	FIRE,
# 	ICE,
# 	BONE,
# 	# add / modify as you like :thumbs_up:
# }

const WORD_GRID_SCENE_PATH = "res://game/level/grid.tscn"

var cell_layout: Dictionary[Vector2i, LetterBox] # position of cell in grid / instance of cell

@export var resource: GridResource = null
@export_category("Nodes")
@export var grid_container: GridContainer
#endregion

#region Private functions
func _ready() -> void:
	#setup(resource)
	pass


func _get_index(row : int, col : int) -> int:
	return resource.grid_size.y*row + col


func _get_coordinates(index: int) -> Vector2i:
	return Vector2i(index / resource.grid_size.y, index % resource.grid_size.y)
#endregion

#region Public functions
## Get the cell at coordinate in row-major coordinates)
##
## [param i,j]: ith-row, jth-column
## [returns]: The associated LetterBox of the Grid
func get_cell_by_coordinates(row : int, col : int) -> LetterBox:
	return grid_container.get_child(_get_index(row, col))


func get_cell_by_index(i: int) -> LetterBox:
	if i >= resource.cell_layout.size():
		return null
	var cell_position = resource.cell_layout.keys()[i]
	return get_cell_by_coordinates(cell_position.x, cell_position.y)


## Get all the [LetterBox] in a single row
func get_row(row: int) -> Dictionary[Vector2i, LetterBox]:
	var coordinates_in_row = cell_layout.keys().filter(func(x):
		return x.x == row and cell_layout[x].status != LetterBox.Status.DISABLED
	)
	var cells_in_row: Dictionary[Vector2i, LetterBox] = {}
	for coord in coordinates_in_row:
		cells_in_row[coord] =  cell_layout[coord]
	return cells_in_row


## Set the cell at given coordinates
##
## [param row, col]: ith-row, jth-column
func set_cell(row : int, col : int, letter_box : LetterBox = null) -> void:
	if letter_box == null:
		letter_box = LetterBox.create(" ", LetterBox.Status.EMPTY)
	var index = _get_index(row, col)
	if index < grid_container.get_child_count():
		var old_node = grid_container.get_child(index)
		old_node.queue_free()
	grid_container.add_child(letter_box)
	grid_container.move_child(letter_box, index)


func get_cell_count() -> int:
	return grid_container.get_children().filter(func(x):
		return x is LetterBox \
			and x.status != LetterBox.Status.DISABLED
	).size()


## Resets the grid.
func reset()-> void:
	grid_container.get_children().map(func(child): child.queue_free())
	setup(resource)


func setup(grid_resource: GridResource) -> void:
	if grid_resource == null and resource == null:
		return
	if grid_resource == null:
		grid_resource = resource
	resource = grid_resource
	grid_container.columns = grid_resource.grid_size.y
	_setup_cells()


func _setup_cells() -> void:
	for row in resource.grid_size.x:
		for col in resource.grid_size.y:
			var letter_box: LetterBox
			if Vector2i(row, col) in resource.cell_layout.keys():
				letter_box = LetterBox.create(" ", LetterBox.Status.EMPTY)
			else:
				letter_box = LetterBox.create(" ", LetterBox.Status.DISABLED)
			set_cell(row, col, letter_box)
			cell_layout[Vector2i(row, col)] = letter_box
