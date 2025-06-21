extends Control
enum TOGGLE_ENUM {MAIN, PLATFORM, BRUSH}
@export var nag_selection: TOGGLE_ENUM
@export var nag_check: CheckBox
@export var main_text: RichTextLabel
@export var title_text: RichTextLabel
@export var title: String
@export var filler: String
func _ready() -> void:
	main_text.text = filler
	title_text.text = title
	match nag_selection:
		TOGGLE_ENUM.MAIN:
			if GlobalData.nag_toggle_main:
				GlobalData.paused = true
		TOGGLE_ENUM.PLATFORM:
			if GlobalData.nag_toggle_platform:
				GlobalData.paused = true
		TOGGLE_ENUM.BRUSH:
			if GlobalData.nag_toggle_brush:
				GlobalData.paused = true

func _on_resume_pressed() -> void:
	self.visible = false
	GlobalData.paused = false


func _on_nag_button_pressed() -> void:
	match nag_selection:
		TOGGLE_ENUM.MAIN:
			GlobalData.nag_toggle_main = !nag_check.button_pressed
		TOGGLE_ENUM.PLATFORM:
			GlobalData.nag_toggle_platform = !nag_check.button_pressed
		TOGGLE_ENUM.BRUSH:
			GlobalData.nag_toggle_brush = !nag_check.button_pressed
