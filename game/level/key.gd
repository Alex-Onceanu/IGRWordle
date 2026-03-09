extends Node2D

signal KeyPress

func setKey(k : String) -> void:
	$Label.text = k

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event.is_pressed()):
		KeyPress.emit($Label.text)
