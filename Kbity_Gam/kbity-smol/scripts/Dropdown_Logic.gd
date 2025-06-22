extends MenuButton

signal popup_menu_selection(type: int, idx: int)
enum CLICK_TYPE {KBITY, TOY, BED, FOOD, LITTER}
@export var click_type: CLICK_TYPE

func _ready():
	# Sets up the popup menu to have a callback method
	self.get_popup().add_theme_font_size_override("font_size", 25)
	self.get_popup().id_pressed.connect(_on_menu_pressed)

func _on_menu_pressed(idx: int) -> void:
	# callback method for popup menu
	popup_menu_selection.emit(click_type, idx)
