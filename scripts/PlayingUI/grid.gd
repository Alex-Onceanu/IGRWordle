extends Control
class_name Grid

#region Variables
var grid_size = Vector2i(5,5)

const GRID_SCENE_PATH = "res://scenes/level_ui/Grid.tscn"
#endregion

#region Private functions
func _ready() -> void:
	$GridContainer.columns = grid_size.y
	for i in range(grid_size.y):
		for j in range(grid_size.x):
			var letter_box = LetterBox.create(" ", LetterBox.Status.EMPTY)
			$GridContainer.add_child(letter_box)

func _get_index(i : int, j : int) -> int:
	return grid_size.y*i+j
#endregion

#region Public functions
## Get the cell at coordinate in row-major coordinates)
##
## [param i,j]: ith-row, jth-column
## [returns]: The associated LetterBox of the Grid
func get_cell(i : int, j : int) -> LetterBox:
	return $GridContainer.get_child(_get_index(i,j))

## Set the cell at coordinate in row-major coordinates)
##
## [param i,j]: ith-row, jth-column
func set_cell(i : int, j : int, n_letter_box : LetterBox) -> void:
	var index = _get_index(i,j)
	var old_node = $GridContainer.get_child(index)
	old_node.queue_free()
	$GridContainer.add_child(n_letter_box)
	$GridContainer.move_child(n_letter_box, index)

## Resets the grid.
func reset()-> void:
	$GridContainer.get_children().map(func(child): child.queue_free())
	_ready()

## Instantiates a grid.
## [param grid_size_v]: grid size coordinates.
## [returns]: A grid instance.
static func create(grid_size_v : Vector2i) -> Grid:
	var scene = load(GRID_SCENE_PATH)
	var node = scene.instantiate()
	node.grid_size = grid_size_v
	return node
#endregion	
