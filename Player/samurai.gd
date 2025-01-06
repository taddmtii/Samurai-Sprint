extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim = get_node("AnimatedSprite2D")

@export var is_alive = true
@export var attacking = false
var skeleton_attacked

func _ready() -> void:
	anim.sprite_frames.set_animation_loop("Attack", false)
	anim.sprite_frames.set_animation_loop("Die", false)
	
func _process(delta):
	if Input.is_action_just_pressed("Attack"): #checks to see if input is the attack button
		attack() #attack

func _physics_process(delta: float) -> void:
	if not is_alive:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta #brings player model down
		#anim.play("Fall") #play fall animation as we go down.

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction == -1: #if we are facing left
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1: #if we are facing right
		get_node("AnimatedSprite2D").flip_h = false
	if direction:
		velocity.x = direction * SPEED
		#anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#anim.play("Idle")

	update_animation() #update animation every frame.
	move_and_slide() #allows movement

func attack():
	var overlapping_objects = $SwordHit.get_overlapping_areas() #checks for everything in collision area, puts into list.
	for area in overlapping_objects:
		var parent = area.get_parent()
		#if parent.fox_health > 0:
		#	parent.take_damage() #will hit anything in that area.
		#elif parent.fox_health == 0:
		#	parent.queue_free()
		
	attacking = true
	anim.play("Attack")
	await anim.animation_finished
	attacking = false
	
func update_animation(): #Handles all move and jump animation logic.
	if is_alive:
		if !attacking: #as long as we are not attacking
			if velocity.x != 0: #if we are not idle
				anim.play("Run")
			else:
				anim.play("Idle")
			if velocity.y < 0:
				anim.play("Jump")
			if velocity.y > 0 and is_alive:
				anim.play("Fall")

func die():
	is_alive = false
	velocity = Vector2.ZERO
	anim.play("Die")
	await anim.animation_finished
	get_tree().reload_current_scene()


func _on_death_wall_body_entered(body: Node2D) -> void:
	if body.name == "Samurai": #If we are the ones who fall off....
		body.die()
	if body.name == "Skeleton": #skeleton ceases to exist.
		body.queue_free()


func _on_sword_hit_body_entered(body: Node2D) -> void:
	if attacking:
		if body.name == "Skeleton":
			skeleton_attacked = get_node("SkeletonDeath")
			print("Skeleton Hit")
			
