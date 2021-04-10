extends KinematicBody2D

const MOVE_RIGHT_KEY = "ui_right"
const MOVE_LEFT_KEY = "ui_left"
const MOVE_UP_KEY = "ui_up"
const MOVE_DOWN_KEY = "ui_down"

const MOVE_SPEED = 4
const MAX_SPEED = 100
const ACCELERATION = 10

var velocity = Vector2.ZERO

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength(MOVE_RIGHT_KEY) - Input.get_action_strength(MOVE_LEFT_KEY)
	input_vector.y = Input.get_action_strength(MOVE_DOWN_KEY) - Input.get_action_strength(MOVE_UP_KEY)
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION
	else:
		velocity = Vector2.ZERO

	move_and_collide(velocity * delta)
