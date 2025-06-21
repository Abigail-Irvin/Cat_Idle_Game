extends Node2D

func _on_new_game_pressed() -> void:
	GlobalData.paused = true
	GlobalData.load_config(GlobalData.CONFIG_DIR + GlobalData.CONFIG_FILE_NAME)
	get_tree().change_scene_to_file("res://scenes/maps/Main.tscn")


func _on_load_game_pressed() -> void:
	GlobalData.load_config(GlobalData.CONFIG_DIR + GlobalData.CONFIG_FILE_NAME)
	GlobalData.load_data(GlobalData.SAVE_DIR + GlobalData.SAVE_FILE_NAME)
	GlobalData.paused = false
	GlobalData.fresh_game = false
	GlobalData.nag_toggle_main = false
	GlobalData.nag_toggle_platform = false
	GlobalData.nag_toggle_brush = false
	get_tree().change_scene_to_file("res://scenes/maps/Main.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()
