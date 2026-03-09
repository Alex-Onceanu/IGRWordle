extends Control
class_name LetterBox
const LETTERBOX_SCENE_PATH = "res://scenes/level_ui/LetterBox.tscn"

enum Status{
	EMPTY,
	WRONG,
	MISPLACED,
	CORRECT,
	DISABLED
}

var status : Status = Status.EMPTY:
	set(status_v):
		status = status_v

var letter : String = "~":
	set(letter_v):
		letter = letter_v
		$Label.text = letter

func _ready() -> void :
	letter = letter
	status = status
	
static func create(letter : String, status_v : Status) -> LetterBox:
	assert(letter.length() == 1, "LetterBox: len(letter) is higher than 1 (%d)" % letter.length())
	var scene = load(LETTERBOX_SCENE_PATH)
	var node = scene.instantiate()
	node.letter = letter
	node.status = status_v
	return node
