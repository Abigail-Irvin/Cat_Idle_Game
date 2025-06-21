extends HBoxContainer
@export var value_name: String
@export var name_ref: RichTextLabel
@export var slider_value: float = 0
@export var slider_ref: HSlider

func _ready():
	name_ref.text = value_name
	slider_ref.value = slider_value

func _process(delta: float) -> void:
	slider_ref.value = slider_value
	
func _on_h_slider_value_changed(value: float) -> void:
	slider_value = value
