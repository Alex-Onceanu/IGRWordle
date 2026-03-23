extends Node
class_name LevelGenerator

static var level_scene := preload("res://game/level/level.tscn")

## experimental
@export_group("Optional")
@export var grid_scene: PackedScene
@export var keyboard_scene: PackedScene
@export var background_scene: PackedScene

# this class should have a function that creates a level scene and returns the root node to the caller


# 1. create grid
# 2. create keyboard
# 3. set own background
# NOTE pass the parameters to build it or build the resource somewhere else and use create_level_from_resource?
static func create_level(word_size: int, max_attempts: int, points_to_pass: int) -> Node:
	return null

# create level from a pre-established [Resource] with all the level information. Useful for debugging
static func create_level_from_resource(level_resource: LevelResource):
	var background_node = level_resource.background_scene.instantiate()
	var keyboard_node = level_resource.keyboard_scene.instantiate()
	# TODO account for variable-sized words in the grid
	var grid_node = level_resource.grid_scene.instantiate()
	var level_node = level_scene.instantiate()

	# call here an specialized constructor? A method in level.gd to organize its elements?
	level_node.add_child(background_node)
	level_node.add_child(keyboard_node)
	level_node.add_child(grid_node)

	keyboard_node.position = Vector2(325, 795)
	grid_node.position = Vector2(325, 343)

	return level_node
