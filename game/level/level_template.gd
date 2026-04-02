extends Node2D
class_name LevelTemplate

# NOTE this script DOES NOT deal with run logic (creating one level after this one)
# This script's sole purpose is to organize the elements visually on the screen for the level. That means:
# - taking a grid, a keyboard, and a background node, and organizing the UI visually
# - making all signal connections needed for the interaction to work
# What this script DOES NOT do:
# - keep updating the UI (the ones who _should_ do this are specialized scripts, such as [for example] PointsLabel, LetterBox, Grid...)


@export var winning_menu: WinningMenuUI
@export var game_over_ui: Control
@export var level_label: RichTextLabel
@export var grid: Grid
@export var keyboard: Keyboard
@export var background: ColorRect
@export var level_manager: LevelManager


var words_list : Array = []


<<<<<<< HEAD
func _ready() -> void:
	setup()

## Sets up the current level's UI elements. It assumes [member LevelTemplate.grid], [member LevelTemplate.keyboard] and
## [member LevelTemplate.background] are set.
func setup() -> void:
	move_child(background, get_child_count() - 1)
	move_child(grid, get_child_count() - 1)
	move_child(keyboard, get_child_count() - 1)
	
	# grid.size = Vector2(229, 200)
	# grid.position = Vector2(220, 278)
	keyboard.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER)
	# keyboard.position = Vector2(325, 971)

	level_manager.grid = grid
=======
## Sets up the current level's UI elements. It assumes [member LevelTemplate.grid], [member LevelTemplate.keyboard] and
## [member LevelTemplate.background] are set.
func setup() -> void:
	add_child(grid)
	add_child(keyboard)
	add_child(background)

	move_child(background, -1)
	move_child(grid, -1)
	move_child(keyboard, -1)
	
	grid.size = Vector2(229, 200)
	grid.position = Vector2(220, 278)
	keyboard.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER)
	keyboard.position = Vector2(325, 971)

	level_manager.grid = grid

	_make_signal_connections()
	

# TODO actually this may not even be needed given SignalBus
func _make_signal_connections() -> void:
	pass
>>>>>>> origin/cell-states
