extends Area2D

var brush_amount = randi_range(1, 3)
var brushed_in = false
var cur_brush_amount = 0
var brush_delay = 0.5 # seconds between entering and exiting brushing
var brush_counter = 0.0
var brush_valid = false # when true you can begin a brush count (in / out)
var start_counter = false
var brush_ref: Node2D

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Brush" and not brushed_in:
		brushed_in = true
		brush_ref = area


func _on_area_exited(area: Area2D) -> void:
	if area.name == "Brush" and brush_valid:
		brush_valid = false
		cur_brush_amount += 1
		brush_ref = area
		
func _process(delta: float) -> void:
	if self.visible:
		if brushed_in:
			start_counter = true
			
		if start_counter:
			brush_counter += delta
		
		if brush_counter >= brush_delay and not brush_valid:
			brush_counter = 0
			brushed_in = false
			start_counter = false
			brush_valid = true
			if brush_ref:
				brush_ref.brush_play()
		
		if cur_brush_amount >= brush_amount:
			self.visible = false
