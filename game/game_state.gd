extends Node


signal points_changed

@export_group("Level")
@export var level: int
@export var points: int:
	set(value):
		points = value
		points_changed.emit()
@export var secret_word: String
@export_group("Player")
@export var coins: int
@export var power_ups: Array[PowerUp]
