extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_run_button_pressed() -> void:
	RunManager._on_main_menu_play_pressed()

func _on_stats_button_pressed() -> void:
	$StatsWindow.show()


func _on_options_button_pressed() -> void:
	$OptionsWindow.show()


func _on_credits_button_pressed() -> void:
	$CreditsWindow.show()
