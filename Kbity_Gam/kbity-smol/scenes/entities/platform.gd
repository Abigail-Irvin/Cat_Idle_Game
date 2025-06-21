extends AnimatableBody2D
@export var commander_ref: Node2D

func _on_coin_body_entered(body: Node2D) -> void:
	commander_ref._on_coin_body_entered(body)
