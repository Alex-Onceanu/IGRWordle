extends Control
class_name Grid

var grid_size = Vector2i(7,5)

const GRID_SCENE_PATH = "res://scenes/level_ui/Grid.tscn"

func _ready() -> void:
	$GridContainer.columns = grid_size.y
	for i in range(grid_size.y):
		for j in range(grid_size.x):
			var letter_box = LetterBox.create(" ", LetterBox.Status.EMPTY)
			$GridContainer.add_child(letter_box)

func get_cell(i : int, j : int) -> LetterBox:
	return $GridContainer.get_child(_get_index(i,j))

func set_cell(i : int, j : int, n_letter_box : LetterBox) -> void:
	var index = _get_index(i,j)
	var old_node = $GridContainer.get_child(index)
	old_node.queue_free()
	$GridContainer.add_child(n_letter_box)
	$GridContainer.move_child(n_letter_box, index)
	
func _get_index(i : int, j : int) -> int:
	return grid_size.y*i+j
	
static func create(grid_size_v : Vector2i) -> Grid:
	var scene = load(GRID_SCENE_PATH)
	var node = scene.instantiate()
	node.grid_size = grid_size_v
	return node
	
