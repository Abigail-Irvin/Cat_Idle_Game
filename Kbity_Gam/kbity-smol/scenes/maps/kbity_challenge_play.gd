extends Node2D
var coin_count = 0
@export var coin_ref: RichTextLabel
@export var energy_ref: RichTextLabel
var platform = preload("res://scenes/entities/platform.tscn") 
var platform_array: Array
@export var right_point: Node2D
@export var left_point: Node2D
@export var end_coin_text: RichTextLabel
@export var return_menu: CanvasLayer
@export var player_ref: Node2D
@export var tutorial: Control
@export var music_player: AudioStreamPlayer2D
var energy_drain = 0.75
var difficulty_scaling: float = 0.1
var counter: float = 10
var max_speed: float = 40
var game_over = false

func _ready():
	if not GlobalData.nag_toggle_platform:
		tutorial.visible = false
		GlobalData.paused = false
	coin_ref.text = "Kbity-Bux gained: " + str(coin_count)
	var node = self.get_child(2)
	platform_array = node.get_children()
	
func _process(delta: float) -> void:
	energy_ref.text = "Energy: " + str(round(GlobalData.energy_level))
	if GlobalData.energy_level <= 0:
		GlobalData.energy_level = 0
		game_over = true
	if game_over and not GlobalData.paused:
		_on_game_over()
	if not GlobalData.paused:
		if counter <= max_speed:
			counter += delta 
		else:
			counter = max_speed
		GlobalData.energy_level -= (energy_drain / (GlobalData.cur_food_level + 1)) * delta
		coin_ref.text = "Kbity-bux gained: " + str(coin_count)
		for node in platform_array:
			node.position.x -= 100 * delta * (difficulty_scaling * counter)
			if node.position.x <= left_point.position.x:
				node.position.x = right_point.position.x
				node.position.y = right_point.position.y + (randi_range(-1, 1) * 250)

func _on_coin_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if GlobalData.happy_level <= 100:
			coin_count += 1
		elif GlobalData.happy_level > 100:
			coin_count += ceil(1 * (GlobalData.cur_toy_level + 1) * ((GlobalData.happy_level / 100) + 1))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		game_over = true


func _on_return_pressed() -> void:
	GlobalData.coins += coin_count
	GlobalData.paused = false
	get_tree().change_scene_to_file("res://scenes/maps/Main.tscn")
	

func _on_game_over() -> void:
	end_coin_text.text = "Coins obtained: " + str(coin_count)
	return_menu.visible = true
	GlobalData.paused = true
	
