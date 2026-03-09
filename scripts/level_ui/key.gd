extends Control
class_name Key

signal key_pressed(key_text : String)

const KEY_SCENE_PATH = "res://scenes/level_ui/Key.tscn"

var key_text : String = "~" :
	set(key_val):
		key_text = key_val
		if has_node("Button"):
			$Button.text = key_text

func _ready() -> void:
	key_text = key_text

func _on_button_button_up() -> void:
	key_pressed.emit(key_text)

static func create(key_val: String) :
	var scene = load(KEY_SCENE_PATH)
	var key_node = scene.instantiate()
	key_node.key_text = key_val
	return key_node
