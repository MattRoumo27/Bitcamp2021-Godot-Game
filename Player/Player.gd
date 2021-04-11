extends KinematicBody2D

const MOVE_RIGHT_KEY = "ui_right"
const MOVE_LEFT_KEY = "ui_left"
const MOVE_UP_KEY = "ui_up"
const MOVE_DOWN_KEY = "ui_down"

const MAX_SPEED = 80
const ROLL_SPEED = 100
const ACCELERATION = 500
const FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength(MOVE_RIGHT_KEY) - Input.get_action_strength(MOVE_LEFT_KEY)
	input_vector.y = Input.get_action_strength(MOVE_DOWN_KEY) - Input.get_action_strength(MOVE_UP_KEY)
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move()

	if Input.is_action_just_pressed("roll"):
		state = ROLL

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state(delta):
	velocity = velocity * 0.8
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE

func attack_animation_finished():
	state = MOVE
