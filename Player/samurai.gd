extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim = get_node("AnimatedSprite2D")

func _ready() -> void:
	anim.play("Idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta #brings player model down
		anim.play("Fall") #play fall animation as we go down.

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction == -1: #if we are facing left
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1: #if we are facing right
		get_node("AnimatedSprite2D").flip_h = false
	if direction:
		velocity.x = direction * SPEED
		anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("Idle")

	move_and_slide()
