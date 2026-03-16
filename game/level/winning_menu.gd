## How to use WinningMenuUI :
##
## You instantiate it like normal (either drag-n-drop in the editor or WinningMenuUI.instantiate()).
## Then you have to :
## use the function append_milestone to append all the milestones triggered during the game.
## use the function set_summary_message to set the final message and the accumulated coins.
extends Control
class_name WinningMenuUI
signal next_level_pressed

#region Variables
var _milestones_list : Array[String] = []
var _values_list : Array[String] = []
#endregion

#region Private functions
func _on_button_button_up() -> void:
	next_level_pressed.emit()
#endregion

#region Public functions
## Add a milestone to show in the UI.
##
## [param milestone]: the name of the reached milestone
## [param value]: the associated value gained from the reached milestone
func append_milestone(milestone : String, value : String) -> void:
	_milestones_list.append(milestone)
	_values_list.append(value)
	$ScrollContainer/VBoxContainer.add_child(Milestone.create(milestone,value))
	
## Set the summary message to show in the UI.
##
## [param desc]: the message to show.
## [param value]: the value to show to the user (usually the sum of the milestones' values).
func set_summary_message(desc : String, value : String):
	$SumMilestone._description = desc
	$SumMilestone._coins_value = value
#endregion
