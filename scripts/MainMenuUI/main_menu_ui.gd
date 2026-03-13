extends Node2D
class_name MainMenuUI

signal play

## Minimal MainMenuUI
func _ready() -> void:
	pass

func _on_button_button_up() -> void:
	play.emit()
