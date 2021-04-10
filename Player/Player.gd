extends KinematicBody2D

const MOVE_RIGHT_KEY = "ui_right"
const MOVE_LEFT_KEY = "ui_left"
const MOVE_UP_KEY = "ui_up"
const MOVE_DOWN_KEY = "ui_down"

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength(MOVE_RIGHT_KEY) - Input.get_action_strength(MOVE_LEFT_KEY)
	input_vector.y = Input.get_action_strength(MOVE_DOWN_KEY) - Input.get_action_strength(MOVE_UP_KEY)
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animationPlayer.play("RunRight")
		else:
			animationPlayer.play("RunLeft")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)
