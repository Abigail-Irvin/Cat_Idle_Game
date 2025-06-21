extends Area2D
var draggable = false
@export var sound_player: AudioStreamPlayer2D

func _on_mouse_entered() -> void:
	draggable = true


func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_pressed("click"):
			self.global_position = get_global_mouse_position()


func _on_mouse_exited() -> void:
	draggable = false

func brush_play() -> void:
	sound_player.play()
