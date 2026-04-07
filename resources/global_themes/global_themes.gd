extends Node

@export var regular_text_theme: Theme
@export var main_color_1: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enable_high_contrast(turn_on):
	if(turn_on):
		regular_text_theme.set_constant("outline_size", "Label", 3)
		regular_text_theme.set_constant("outline_size", "CheckButton", 3)
	else:
		regular_text_theme.set_constant("outline_size", "Label", 0)
		regular_text_theme.set_constant("outline_size", "CheckButton", 0)
	ResourceSaver.save(regular_text_theme)


func is_high_contrast_enabled():
	return regular_text_theme.get_constant("outline_size", "Label") > 0
