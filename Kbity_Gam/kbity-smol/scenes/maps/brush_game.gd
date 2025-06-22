extends Node2D
@export var dust_group: Node2D
@export var brush_ref: Node2D
@export var return_menu: CanvasLayer
@export var happy_obtained: RichTextLabel
@export var tutorial: Control
var dust_array: Array
var clean_total: int
var cur_clean: int = 0

func _ready() -> void:
	if not GlobalData.nag_toggle_brush:
		tutorial.visible = false
		GlobalData.paused = false
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
	GlobalData.coins += 10
	GlobalData.happy_level += 10
	GlobalData.paused = false
	get_tree().change_scene_to_file("res://scenes/maps/Main.tscn")

func _on_game_over() -> void:
	happy_obtained.text = "Coins gained: 10"
	return_menu.visible = true
