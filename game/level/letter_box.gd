extends Control
class_name LetterBox

#region Variables
const LETTERBOX_SCENE_PATH = "res://game/level/letter_box.tscn"

enum Status{
	EMPTY,
	FULL,
	WRONG,
	MISPLACED,
	CORRECT,
	DISABLED,
}

const STATUS_COLORS = {
	Status.EMPTY: Color(0.862, 0.849, 0.846),
	Status.FULL: Color(0.862, 0.849, 0.846),
	Status.WRONG: Color(0.325, 0.325, 0.325),
	Status.MISPLACED: Color(1, 0.8, 0.2),
	Status.CORRECT: Color(0.384, 0.873, 0.0),
	Status.DISABLED: Color(0.094, 0.094, 0.094)
}

var status : Status = Status.EMPTY:
	set(status_v):
		status = status_v
		$TextureRect.modulate = STATUS_COLORS[status]

var letter : String = "~":
	set(letter_v):
		letter = letter_v.to_upper()
		$Label.text = letter
#endregion

#region Private functions
func _ready() -> void :
	letter = letter.to_upper()
	status = status
#endregion

#region Public functions
## Instantiates a LetterBox.
##
## [param letter]: The letter to show.
## [param status_v]: The current Letterbox.Status of the letter.
## [returns]: an instance of LetterBox with the right parameters.
static func create(letter : String, status_v : Status) -> LetterBox:
	assert(letter.length() == 1, "LetterBox: len(letter) is higher than 1 (%d)" % letter.length())
	var scene = load(LETTERBOX_SCENE_PATH)
	var node = scene.instantiate() as LetterBox
	node.letter = letter
	node.status = status_v
	return node
#endregion
