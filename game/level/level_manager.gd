extends Node
class_name LevelManager

# this class deals with the logic of the _current_ level. That means:
# - it comprises everything that is data, as opposed to visual elements
# - it generates a random secret word in such a way that is coherent to the grid's layout (size and position of the last row)
# - it checkes for words in the dictionary with every attempt
# - it calls the right functions for typing letters (LetterBox)
# - it keeps track of how many points the player has
# - it keeps track of the "challenges" the player has to complete to gain coins (coin power-ups)
# - it keeps track of word resolution (ordering of effect resolution function calls, total number of points scored, etc.)
# TODO create files for each word size, or organize words.txt into a JSON with word sizes 
const WORDS_PATH : String = "res://words.txt"

@export var receiver: SignalBusReceiver

var next_cell_to_fill_idx: int = 0
var current_row: int = 0
var current_guess: String = ""
var grid: Grid


func get_next_cell_to_fill() -> void:
	return grid.get_cell_by_index(next_cell_to_fill_idx)


func _get_next_row() -> int:
	var idx = grid.resource.cell_layout.keys().find_custom(func(x): return x.x > current_row)
	if idx == -1:
		return current_row
	return grid.resource.cell_layout.keys()[idx].x


func _is_last_cell_in_row() -> bool:
	return next_cell_to_fill_idx >= grid.get_cell_count() \
		or grid.resource.cell_layout.keys()[next_cell_to_fill_idx].x > current_row


func _is_valid_guess() -> bool:
	return true
	

func _on_keyboard_character_pressed(c: String) -> void:
	if _is_last_cell_in_row():
		return
	current_guess += c 
	var letter_box := grid.get_cell_by_index(next_cell_to_fill_idx)
	next_cell_to_fill_idx += 1
	letter_box.letter = c
	letter_box.status = LetterBox.Status.FULL


func _on_keyboard_delete_pressed() -> void:
	print("current guess is ", current_guess)
	if current_guess == "":
		return
	current_guess = current_guess.erase(current_guess.length() - 1, 1)
	next_cell_to_fill_idx -= 1
	var letter_box := grid.get_cell_by_index(next_cell_to_fill_idx)
	letter_box.letter = " "
	letter_box.status = LetterBox.Status.EMPTY
	

func _on_keyboard_enter_pressed() -> void:
	if not _is_valid_guess():
		print("not a valid guess")
		return
	# TODO resolve guess, effects, and earn points
	current_row = _get_next_row()
	current_guess = ""
