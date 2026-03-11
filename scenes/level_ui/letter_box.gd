extends Control
class_name LetterBox
const LETTERBOX_SCENE_PATH = "res://scenes/level_ui/LetterBox.tscn"

enum Status{
	EMPTY,
	FULL,
	WRONG,
	MISPLACED,
	CORRECT,
	DISABLED,
}

func _get_status_color(status: Status) -> Color:
	match status:
		Status.EMPTY:
			return Color(0.862, 0.849, 0.846, 1.0)
		Status.FULL:
			return Color(0.862, 0.849, 0.846, 1.0)
		Status.WRONG:
			return Color(0.325, 0.325, 0.325, 1.0)
		Status.MISPLACED:
			return Color(1, 0.8, 0.2)
		Status.CORRECT:
			return Color(0.384, 0.873, 0.0, 1.0)
		Status.DISABLED:
			return Color(0.094, 0.094, 0.094, 1.0)
		_:
			return Color.WHITE

var status : Status = Status.EMPTY:
	set(status_v):
		status = status_v
		$TextureRect.modulate = _get_status_color(status)

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
