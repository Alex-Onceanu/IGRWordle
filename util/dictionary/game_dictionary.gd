extends Node
## Class for loading a dictionary into the game and consulting it. It provides an API for
## consulting whether a word is or not in the dictionary, and also to randomly pick words.

const DICTIONARY_FILE_PATH = "res://util/dictionary/english_dictionary_2.json"
var words: Dictionary = {}


func _ready() -> void:
	_load_dictionary(DICTIONARY_FILE_PATH)


func pick_random_word_of_size(size: int) -> String:
	return words[str(size)].keys().pick_random()


func is_in_dictionary(word: String) -> bool:
	var word_size = word.length()
	return words[str(word_size)].has(word)


func get_definitions(word: String) -> Array:
	if not is_in_dictionary(word):
		return {}
	var word_size = word.length()
	return words[str(word_size)][word]["meanings"]


static func format_dictionary_data(data: Dictionary) -> String:
	var bbcode = ""
	if data.has("MEANINGS"):
		bbcode += "[p][font_size=24][b]Definitions[/b][/font_size][/p]\n"
		
		for meaning in data["MEANINGS"]:
			var part_of_speech = meaning[0]
			var definition = meaning[1] + "."
			
			bbcode += "[color=blue][i]" + part_of_speech + "[/i][/color]: "
			bbcode += definition + "\n"
			bbcode += "\n"
	if data.has("SYNONYMS") and data["SYNONYMS"].size() > 0:
		bbcode += "[b][color=dark_green]Synonyms:[/color][/b] "
		bbcode += ", ".join(data["SYNONYMS"]) + "\n\n"
	
	if data.has("ANTONYMS") and data["ANTONYMS"].size() > 0:
		bbcode += "[b][color=red]Antonyms:[/color][/b] "
		bbcode += ", ".join(data["ANTONYMS"]) + "\n"
	return bbcode


func _load_dictionary(path: String) -> void:
	if not FileAccess.file_exists(path):
		print("Dictionary file does not exist.")
		return
	var data_file = FileAccess.open(path, FileAccess.READ)
	var parsed_result = JSON.parse_string(data_file.get_as_text())
	if not parsed_result is Dictionary:
		print("Error loading dictionary.")
		return 
	words = parsed_result
