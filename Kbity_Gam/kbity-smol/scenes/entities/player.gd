extends CharacterBody2D
var jump_impulse = 700

func _physics_process(delta: float) -> void:
	if not GlobalData.paused:
		self.velocity.y += 800 * delta
		
		if is_on_floor() and Input.is_action_pressed("jump"):
			self.position.y -= 5
			self.velocity.y -= jump_impulse 
		
		if Input.is_action_pressed("left"):
			self.velocity.x -= (600 * delta) * (GlobalData.happy_level / 100)
		if Input.is_action_pressed("right"):
			self.velocity.x += (600 * delta) * (GlobalData.happy_level / 100)
		elif not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
			if is_on_floor():
				velocity.x = lerp(velocity.x, 0.0, 0.2)
		move_and_slide()
