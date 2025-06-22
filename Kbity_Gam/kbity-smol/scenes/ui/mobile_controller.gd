extends Control
var left_pressed = false
var right_pressed = false
var jump_pressed = false

func _generic_input_process(type: String, value: bool):
	var input_action  = InputEventAction.new()
	input_action.action = type
	input_action.pressed = value
	Input.parse_input_event(input_action)

func _process(delta: float) -> void:
	if left_pressed:
		_generic_input_process("left", true)
	else:
		_generic_input_process("left", false)
	if right_pressed:
		_generic_input_process("right", true)
	else:
		_generic_input_process("right", false)
	if jump_pressed:
		_generic_input_process("jump", true)
	else:
		_generic_input_process("jump", false)


func _on_left_pressed() -> void:
	left_pressed = true


func _on_left_released() -> void:
	left_pressed = false


func _on_jump_pressed() -> void:
	jump_pressed = true


func _on_jump_released() -> void:
	jump_pressed = false


func _on_right_pressed() -> void:
	right_pressed = true


func _on_right_released() -> void:
	right_pressed = false
