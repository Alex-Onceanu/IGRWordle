extends Node
class_name RunManager

# this is the class that will deal with the flow of a run. It is responsible for establishing each step of the
# main gameplay loop, getting data from it and transitioning between scenes according to it. It will:
# - call random level creation
# - go to the "win coins" scene once the player finished the level, or to the game over one otherwise
# - go to the shop scene once the player obtained their coins
# - go to a new level after the player leaves the shop
# That means that for all the buttons the player presses to go from one scene to another, the one class that deals with those
# signals is this one
@export var run_progression_list: Array[RunProgression]
# NOTE: this script needs to:
# - go to win screen when level is won
# - go to game over screen when level is failed
# - go to shop when button is pressed on win screen
# - generate a new level when exiting shop


func _on_level_manager_level_lost() -> void:
	pass


func _on_level_manager_level_won() -> void:
	pass # Replace with function body.


func _on_shop_manager_next_level_pressed() -> void:
	pass # Replace with function body.


func _on_winning_menu_next_level_pressed() -> void:
	pass # Replace with function body.
