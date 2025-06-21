extends Node2D
@export var dust_group: Node2D
@export var brush_ref: Node2D
@export var return_menu: CanvasLayer
@export var happy_obtained: RichTextLabel
var dust_array: Array
var clean_total: int
var cur_clean: int = 0

func _ready() -> void:
	dust_array = dust_group.get_children()
	clean_total = len(dust_array)
	
func _process(delta: float) -> void:
	if not GlobalData.paused:
		for dust in dust_array:
			if not dust.visible:
				cur_clean += 1
		if cur_clean >= clean_total:
			GlobalData.paused = true
			brush_ref.visible = false
			brush_ref.set_process(false)
			_on_game_over()
		else:
			cur_clean = 0

func _on_return_pressed() -> void:
	GlobalData.happy_level += 20
	get_tree().change_scene_to_file("res://scenes/maps/Main.tscn")

func _on_game_over() -> void:
	happy_obtained.text = "Happiness gained: 20"
	return_menu.visible = true
