extends Control
@export var options_ref: MarginContainer
@export var selection_ref: MarginContainer

@export var master_ref: HBoxContainer
@export var music_ref: HBoxContainer
@export var sfx_ref: HBoxContainer

func _ready() -> void:
	master_ref.slider_value = GlobalData.master_volume
	music_ref.slider_value = GlobalData.music_volume
	sfx_ref.slider_value = GlobalData.sfx_volume
	
func _on_resume_pressed() -> void:
	GlobalData.paused = false
	selection_ref.visible = false
	options_ref.visible = false


func _on_options_pressed() -> void:
	options_ref.visible = true


func _on_save_pressed() -> void:
	GlobalData.save_data(GlobalData.SAVE_DIR + GlobalData.SAVE_FILE_NAME)


func _on_quit_pressed() -> void:
	_on_save_pressed()
	get_tree().change_scene_to_file("res://scenes/maps/title_map.tscn")


func _on_pause_pressed() -> void:
	GlobalData.paused = true
	if selection_ref.visible:
		selection_ref.visible = false
		options_ref.visible = false
	else:
		selection_ref.visible = true


func _on_close_pressed() -> void:
	options_ref.visible = false
	GlobalData.save_config(GlobalData.CONFIG_DIR + GlobalData.CONFIG_FILE_NAME)
	
func _process(delta: float) -> void:
	# updates global values for sound
	GlobalData.master_volume = master_ref.slider_value
	GlobalData.music_volume = music_ref.slider_value
	GlobalData.sfx_volume = sfx_ref.slider_value
