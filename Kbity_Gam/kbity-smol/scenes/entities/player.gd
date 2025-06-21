extends CharacterBody2D
@export var animator: AnimatedSprite2D
var jump_impulse = 700
@export var meower: AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	if not GlobalData.paused:
		self.velocity.y += 800 * delta
		
		if is_on_floor() and Input.is_action_pressed("jump"):
			self.position.y -= 5
			self.velocity.y -= jump_impulse 
			meower.play()
		
		if Input.is_action_pressed("left"):
			self.velocity.x -= (600 * delta) * (GlobalData.happy_level / 100)
			if animator.animation != "running" or not animator.flip_h:
				animator.animation = "running"
				animator.flip_h = true
				if is_on_floor():
					animator.play("running")
		if Input.is_action_pressed("right"):
			self.velocity.x += (600 * delta) * (GlobalData.happy_level / 100)
			if animator.animation != "running" or animator.flip_h:
				animator.animation = "running"
				animator.flip_h = false
				if is_on_floor():
					animator.play("running")
		elif not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
			if is_on_floor():
				if animator.animation != "idle":
					animator.animation = "idle"
					animator.play("idle")
				velocity.x = lerp(velocity.x, 0.0, 0.2)
		if is_on_floor() and animator.animation == "running":
			if not animator.is_playing():
				animator.play("running")
		elif not is_on_floor() and animator.animation == "running":
			animator.stop()
		move_and_slide()
