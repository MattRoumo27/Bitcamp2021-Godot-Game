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
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength(MOVE_RIGHT_KEY) - Input.get_action_strength(MOVE_LEFT_KEY)
	input_vector.y = Input.get_action_strength(MOVE_DOWN_KEY) - Input.get_action_strength(MOVE_UP_KEY)
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)
