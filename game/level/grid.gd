extends Control
class_name Grid

#region Variables
const WORD_GRID_SCENE_PATH = "res://game/level/grid.tscn"

var word_grid_size = Vector2i(5,5)
#endregion

#region Private functions
func _ready() -> void:
	$GridContainer.columns = word_grid_size.y
	for i in range(word_grid_size.y):
		for j in range(word_grid_size.x):
			var letter_box = LetterBox.create(" ", LetterBox.Status.EMPTY)
			$GridContainer.add_child(letter_box)

func _get_index(i : int, j : int) -> int:
	return word_grid_size.y*i+j
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
	var scene = load(WORD_GRID_SCENE_PATH)
	var node = scene.instantiate()
	node.grid_size = grid_size_v
	return node
#endregion	
