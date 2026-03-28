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
