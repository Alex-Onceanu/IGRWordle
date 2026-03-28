extends Node2D
class_name LevelGenerator


@export var level_template_scene: PackedScene = preload("res://game/level/level_template.tscn")
@export var grid_scene: PackedScene
@export var keyboard_scene: PackedScene
@export var background_scene: PackedScene


## This function builds a [Level] from [Grid], [Keyboard], and [Background] resources.
## It returns the root node of the generated [Level] scene.
func generate_level(grid_resource: GridResource, keyboard_resource: Resource, background_resource: Resource):
	var level_template_node = level_template_scene.instantiate()
	var grid_node = grid_scene.instantiate()
	var keyboard_node = keyboard_scene.instantiate()
	var background_node = background_scene.instantiate()

	grid_node.setup(grid_resource)
	#keyboard_node.setup(keyboard_resource)
	#background_node.setup(background_resource)
	level_template_node.grid = grid_node
	level_template_node.keyboard = keyboard_node
	level_template_node.background = background_node
	level_template_node.setup()

	return level_template_node
