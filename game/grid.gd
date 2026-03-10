extends Node2D

var LETTER_SCENE = preload("res://scenes/letter.tscn")
@export var DIM := Vector2i(5, 5) # replace this with 2D array
const CELL_SIZE := Vector2(70, 70)
const PADDING := Vector2(10.0, 10.0)
var allWords : String
var nextCell := Vector2i()
var mysteryWord : String
@onready var word := ""

func _ready() -> void:
	allWords = FileAccess.get_file_as_string("words.txt")
	mysteryWord = allWords.substr(6 * randi_range(0, len(allWords) / 6 - 1), 5)
	var topLeft := -(PADDING + CELL_SIZE) * (DIM / 2.0 - Vector2(0.5, 0.5))
	for y in range(DIM.x):
		for x in range(DIM.y):
			var letter = LETTER_SCENE.instantiate()
			letter.name = str(x) + "_" + str(y)
			# letter.get_node("Label").text = String.chr(65 + randi_range(0, 25))
			letter.position = topLeft + (PADDING + CELL_SIZE) * Vector2(x, y)
			add_child(letter)


func okOrNot(ok : bool, no : bool):
	$Ok.visible = ok
	$No.visible = no


func displayLetter(k : String) -> void:
	if nextCell.y >= DIM.x or nextCell.x >= DIM.y:
		return
	get_node(str(nextCell.x) + "_" + str(nextCell.y) + "/Label").text = k
	word += k.to_lower()
	nextCell.x += 1

	get_node("../Keyboard/Del").disabled = false
	if nextCell.x >= DIM.x:
		if word in allWords:
			okOrNot(true, false)
			get_node("../Keyboard/Enter").disabled = false
		else:
			okOrNot(false, true)


func keyCallback(k : String) -> void:
	print("key press received!")
	displayLetter(k)


func delCallback() -> void:
	print("delete press received!")
	nextCell.x -= 1
	get_node(str(nextCell.x) + "_" + str(nextCell.y) + "/Label").text = ""
	word = word.substr(0, len(word) - 1)

	okOrNot(false, false)
	get_node("../Keyboard/Enter").disabled = true
	if nextCell.x <= 0:
		get_node("../Keyboard/Del").disabled = true


func colorOfLetter(i : int) -> Color:
	if word[i] == mysteryWord[i]:
		return Color.GREEN
	elif word[i] in mysteryWord:
		return Color.YELLOW
	else:
		return Color(0.4, 0.4, 0.4, 1.0)


func enterCallback() -> void:
	print("enter press received!")
	for i in range(DIM.x):
		var clr = colorOfLetter(i)
		get_node(str(i) + "_" + str(nextCell.y) + "/Background").\
			material.set_shader_parameter("clr", clr)
	nextCell = Vector2i(0, nextCell.y + 1)
	get_node("../Keyboard/Del").disabled = true
	get_node("../Keyboard/Enter").disabled = true
	word = ""
	okOrNot(false, false)
	$Ok.position.y += (CELL_SIZE.x + PADDING.x)
	$No.position = $Ok.position
