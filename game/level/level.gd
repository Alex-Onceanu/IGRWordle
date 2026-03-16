extends Node2D
class_name Level

# TODO change all node references to export variables
signal return_to_main_menu

#region Variables
var words_list : Array = []
const WORDS_PATH : String = "res://words.txt"
#endregion

#region Private functions
func _ready():
	new_game()
	$Keyboard.char_pressed.connect(char_pressed_callback)
	$Keyboard.enter_pressed.connect(enter_pressed_callback)
	$Keyboard.del_pressed.connect(del_pressed_callback)
	$GameOverUI.hide()
	$NextLevelUI.hide()
#endregion

#region Public functions
func char_pressed_callback(c : String) -> void:
	if (len($GameState.current_string_guess) < $Grid.grid_size.y) && ($GameState.current_attempt<$Grid.grid_size.x):
		$GameState.current_string_guess+=c
		var letter_box : LetterBox = $Grid.get_cell($GameState.current_attempt, len($GameState.current_string_guess)-1)
		letter_box.letter = c
		letter_box.status = LetterBox.Status.FULL

func enter_pressed_callback() -> void:
	var letters_mystery_word = $GameState.mystery_word.split("")
	if (len($GameState.current_string_guess) >= $Grid.grid_size[1]):
		if ($GameState.current_string_guess not in words_list):
			print("word doesn't exist !")
			return
		var number_correct : int = 0
		for j in range(len($GameState.current_string_guess)):
			if ($GameState.current_string_guess[j] == $GameState.mystery_word[j]):
				letters_mystery_word.erase($GameState.current_string_guess[j])
				var letter_box : LetterBox = $Grid.get_cell($GameState.current_attempt, j)
				letter_box.status = LetterBox.Status.CORRECT
				var key : KeyboardKey = $Keyboard.get_key($GameState.current_string_guess[j])
				var texture_rect : Button = key.find_child("Button")
				texture_rect.modulate = Color(0.0, 0.698, 0.0, 1.0)
				number_correct+=1
			elif ($GameState.current_string_guess[j] in letters_mystery_word):
				letters_mystery_word.erase($GameState.current_string_guess[j])
				var letter_box : LetterBox = $Grid.get_cell($GameState.current_attempt, j)
				letter_box.status = LetterBox.Status.MISPLACED
				var key : KeyboardKey = $Keyboard.get_key($GameState.current_string_guess[j])
				var texture_rect : Button = key.find_child("Button")
				texture_rect.modulate = Color(0.0, 0.698, 0.0, 1.0)
			else :
				var letter_box : LetterBox = $Grid.get_cell($GameState.current_attempt, j)
				letter_box.status = LetterBox.Status.WRONG
				var key : KeyboardKey = $Keyboard.get_key($GameState.current_string_guess[j])
				var texture_rect : Button = key.find_child("Button")
				texture_rect.modulate = Color(0.273, 0.273, 0.273, 1.0)
		if (number_correct == $Grid.grid_size.y):
			print("YOU WIN !")
			$NextLevelUI.show()
			return
		else :
			$GameState.current_string_guess = ""
			$GameState.current_attempt+=1
		
		if ($GameState.current_attempt >= $Grid.grid_size.x):
			$GameOverUI.show()
			print("GAME OVER !")
		else :
			print("TRY AGAIN !")
	else :
		print("not enough letters ! doing nothing")

func del_pressed_callback() -> void :
	if len($GameState.current_string_guess) > 0:
		$GameState.current_string_guess = $GameState.current_string_guess.left(len($GameState.current_string_guess) - 1)
		var letter_box : LetterBox = $Grid.get_cell($GameState.current_attempt, len($GameState.current_string_guess))
		letter_box.letter = " "
		letter_box.status = LetterBox.Status.EMPTY

#TODO : Parameterize the new_game function (add grid size for example) 
## Starts a new game.
func new_game() -> void:
	reset_game(false)

## Reset data :
## Resets game variables. 
## If next_level is true, it prepares for the next round.
## If false, it resets the entire session (Hard Reset).
func reset_game(next_level : bool) -> void:
	# Reseting the elements
	$Grid.reset()
	$Keyboard.reset()
	$GameOverUI.hide()
	$NextLevelUI.hide()
	# Reseting data the right way
	$GameState.mystery_word = ""
	$GameState.current_string_guess = ""
	$GameState.current_attempt = 0
	if next_level:
		$GameState.level += 1
		print("Starting level: ", $GameState.level)
	else:
		$GameState.level = 1
		$GameState.points = 0
		$GameState.coins = 0
		$GameState.power_ups.clear()
		print("Game fully reset.")
		assert(FileAccess.file_exists(WORDS_PATH), "core_game.gd : run aborted because couldn't reach the file on path " + WORDS_PATH)
	# re-picking a random word.
	var content = FileAccess.get_file_as_string(WORDS_PATH)
	var raw_words_list = content.split("\n", false)
	for word in raw_words_list:
		var clean_word = word.strip_edges()
		words_list.append(clean_word.to_upper())
	var current_mystery_word = words_list.pick_random()
	if words_list.size() > 0:
		print("secret word is ", current_mystery_word)
	else:
		push_error("No 5 letters word was found in the file")
	$GameState.mystery_word = current_mystery_word

func next_level_game() -> void:
	reset_game(true)
	
#endregion

func _on_restart_game_button_button_up() -> void:
	new_game()

func _on_return_main_menu_button_up() -> void:
	return_to_main_menu.emit()

func _on_next_level_button_button_up() -> void:
	next_level_game()
