extends Node2D

var current_attempt : int = 0
var current_string_guess : String = ""
var current_mystery_word : String = ""
var words_list : Array = []
const WORDS_PATH : String = "res://words.txt"

func _ready():
	$Keyboard.char_pressed.connect(char_pressed_callback)
	$Keyboard.enter_pressed.connect(enter_pressed_callback)
	$Keyboard.del_pressed.connect(del_pressed_callback)
	
	assert(FileAccess.file_exists(WORDS_PATH), "core_game.gd : run aborted because couldn't reach the file on path " + WORDS_PATH)
	var content = FileAccess.get_file_as_string(WORDS_PATH)
	var raw_words_list = content.split("\n", false)

	for word in raw_words_list:
		var clean_word = word.strip_edges()
		words_list.append(clean_word.to_upper())

	if words_list.size() > 0:
		current_mystery_word = words_list.pick_random()
		print("secret word is ", current_mystery_word)
	else:
		push_error("No 5 letters word was found in the file")

func char_pressed_callback(c : String) -> void:
	if len(current_string_guess) < $Grid.grid_size.y :
		current_string_guess+=c
		var letter_box : LetterBox = $Grid.get_cell(current_attempt, len(current_string_guess)-1)
		letter_box.letter = c
		letter_box.status = LetterBox.Status.FULL

func enter_pressed_callback() -> void:
	var letters_mystery_word = current_mystery_word.split("")
	if (len(current_string_guess) >= $Grid.grid_size[1]):
		if (current_string_guess not in words_list):
			print("word doesn't exist !")
			return
		var number_correct : int = 0
		for j in range(len(current_string_guess)):
			if (current_string_guess[j] == current_mystery_word[j]):
				letters_mystery_word.erase(current_string_guess[j])
				var letter_box : LetterBox = $Grid.get_cell(current_attempt, j)
				letter_box.status = LetterBox.Status.CORRECT
				number_correct+=1
			elif (current_string_guess[j] in letters_mystery_word):
				letters_mystery_word.erase(current_string_guess[j])
				var letter_box : LetterBox = $Grid.get_cell(current_attempt, j)
				letter_box.status = LetterBox.Status.MISPLACED
			else :
				var letter_box : LetterBox = $Grid.get_cell(current_attempt, j)
				letter_box.status = LetterBox.Status.WRONG
			
		if (number_correct == $Grid.grid_size.y):
			print("YOU WIN !")
			return
		else :
			current_string_guess = ""
			current_attempt+=1
		
		if (current_attempt >= $Grid.grid_size.x):
			print("YOU LOSE !")
		else :
			print("TRY AGAIN !")
	else :
		print("not enough letters ! doing nothing")

func del_pressed_callback() -> void :
	if len(current_string_guess) > 0:
		current_string_guess = current_string_guess.left(len(current_string_guess) - 1)
		var letter_box : LetterBox = $Grid.get_cell(current_attempt, len(current_string_guess))
		letter_box.letter = " "
		letter_box.status = LetterBox.Status.EMPTY
		
