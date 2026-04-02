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

@export var receiver: SignalBusReceiver

var next_cell_to_fill_idx: int = 0
var current_row: int = 0
var current_guess: String = ""
var correct_letters_in_guess: int = 0
var grid: Grid
var keyboard: Keyboard
var secret_word: Dictionary[String, int] # (character, column)


func choose_secret_word() -> void: 
	if not grid:
		push_error("there is no grid for generating secret word!")
	var last_row: int = -1
	for coord in grid.cell_layout.keys():
		last_row = max(last_row, coord.x)
	var last_row_cells = grid.get_row(last_row)
	print("cells in last row are: ", last_row_cells)
	var secret_word_string := GameDictionary.pick_random_word_of_size(last_row_cells.size())
	for i in secret_word_string.length():
		secret_word[secret_word_string[i]] = last_row_cells.keys()[i].y
	print("secret word is: ", secret_word_string)
	print(secret_word)
	

func get_next_cell_to_fill() -> void:
	return grid.get_cell_by_index(next_cell_to_fill_idx)


func resolve_guess() -> void:
	var row_letters := grid.get_row(current_row)
	for coord in row_letters:
		_resolve_letter_guess(coord, row_letters[coord])
		_resolve_letter_effect(coord, row_letters[coord])
	if correct_letters_in_guess == secret_word.keys().size():
		_win()
	correct_letters_in_guess = 0


func _resolve_letter_guess(coordinates: Vector2i, letter: LetterBox):
	if letter.letter in secret_word.keys():
		if coordinates.y == secret_word[letter.letter]:
			letter.correctness = LetterBox.Correctness.CORRECT
			correct_letters_in_guess += 1
		else:
			letter.correctness = LetterBox.Correctness.MISPLACED
	else:
		letter.correctness = LetterBox.Correctness.WRONG
	keyboard.update_letter(letter.letter, letter.correctness)


func _resolve_letter_effect(coordinates: Vector2i, letter: LetterBox):
	# call here the "apply_effect()" or equivalent in the PowerUp stored in the LetterBox instance.
	pass


func _get_next_row() -> int:
	var idx = grid.resource.cell_layout.keys().find_custom(func(x): return x.x > current_row)
	if idx == -1:
		return current_row
	return grid.resource.cell_layout.keys()[idx].x


func _is_last_cell_in_row() -> bool:
	return next_cell_to_fill_idx >= grid.get_cell_count() \
		or grid.resource.cell_layout.keys()[next_cell_to_fill_idx].x > current_row


func _is_valid_guess() -> bool:
	return _is_last_cell_in_row() and GameDictionary.is_in_dictionary(current_guess)
	

func _win() -> void:
	print("you won... now what?")


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
	resolve_guess()
	current_row = _get_next_row()
	current_guess = ""
