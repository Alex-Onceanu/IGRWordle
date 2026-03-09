extends Control

signal enter_pressed
signal del_pressed
signal char_pressed(string :String)

var key_rows : Array[HBoxContainer] = []
var string_rows : Array[String] = ["AZERTYUIOP", "QSDFGHJKLM", "WXCVBN"]

var current_string 

func _ready() -> void:
	key_rows.append($VBoxContainer/row1)
	key_rows.append($VBoxContainer/row2)
	key_rows.append($VBoxContainer/row3)
	assert(len(string_rows) == len(key_rows), "string rows and key rows are not equal !")
	
	for i in range(len(key_rows)):
		var row = key_rows[i]
		for key_text in string_rows[i]:
			var key = Key.create(key_text)
			row.add_child(key)
			print("key was added : ", key_text)
			key.key_pressed.connect(_on_char_pressed)

func _on_enter_button_up() -> void:
	enter_pressed.emit()

func _on_del_button_up() -> void:
	del_pressed.emit()

func _on_char_pressed(char : String) -> void:
	char_pressed.emit(char)
	
