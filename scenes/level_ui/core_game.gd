extends Node2D

var current_attempt : int = 0
var current_string_guess : String = ""
var current_mystery_word : String = ""

func _onready():
	$Keyboard.char_pressed.connect()
	$Keyboard.enter_pressed.connect()
	$Keyboard.del_pressed.connect()
	var all_words = FileAccess.get_file_as_string("words.txt")
	current_mystery_word = all_words.substr(6 * randi_range(0, len(all_words) / 6 - 1), 5)

func char_pressed_callback() -> void:
	pass

func enter_pressed_callback() -> void:
	var letters_mystery_word = current_mystery_word.split("")
	if (len(current_string_guess) >= $Grid.grid_size[1]):
		for j in range(len(current_string_guess)):
			if (current_string_guess[j] == current_mystery_word[j]):
				var letter_box = $Grid.get_cell(current_attempt, j)
				var rect = letter_box.get_node("TextureRect") as TextureRect
				rect.self_modulate = Color.FOREST_GREEN
			elif (current_string_guess[j] in letters_mystery_word):
				pass
			else :
				pass
	else :
		pass

func del_pressed_callback() -> void :
	pass
	
