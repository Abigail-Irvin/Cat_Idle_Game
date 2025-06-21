extends Area2D
var countdown = 5
var counter = 0

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and self.visible:
		self.visible = false
		self.get_parent()._on_coin_body_entered(body)
		

func _process(delta: float) -> void:
	if not self.visible:
		counter += delta
	if counter >= countdown:
		counter = 0
		self.visible = true
