extends Node
class_name LevelManager

# this class deals with the logic of the _current_ level. That means:
# - it comprises everything that is data, as opposed to visual elements
# - it generates a random secret word in such a way that is coherent to the grid's layout (size and position of the last row)
# - it checkes for words in the dictionary with every attempt
# - it calls the right functions for typing letters (LetterBox)
# - it keeps track of how many points the player has
# - it keeps track of the "challenges" the player has to complete to gain coins (coin power-ups)
# - it keeps track of word resolution (ordering of effect resolution function calls, total number of points scored, etc.)
