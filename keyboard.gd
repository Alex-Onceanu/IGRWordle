extends Node2D

signal DelPressed
signal EnterPressed

const KEY_SCENE := preload("res://key.tscn")
const KEYBOARD := "QWERTYUIOPASDFGHJKLZZXCVBNM"
const PADDING := Vector2(12.0, 24.0)
const CELL_SIZE := Vector2(48.0, 72.0)
const DIMS : Array[int] = [10, 9, 7]

func _ready() -> void:
	DelPressed.connect(get_node("../Grid").delCallback)
	EnterPressed.connect(get_node("../Grid").enterCallback)

	var topLeft := -(PADDING + CELL_SIZE) * (Vector2(9, 2) / 2.0)
	for y in range(3):
		for x in range(DIMS[y]):
			var i := y * DIMS[y] + x
			var key = KEY_SCENE.instantiate()
			key.name = KEYBOARD[i]
			key.get_node("Label").text = KEYBOARD[y * 10 + x]
			key.position = topLeft + (PADDING + CELL_SIZE) * Vector2(x + y / 2.0, y)
			key.KeyPress.connect(get_node("../Grid").keyCallback)
			add_child(key)

func _on_del_pressed() -> void:
	DelPressed.emit()

func _on_enter_pressed() -> void:
	EnterPressed.emit()
