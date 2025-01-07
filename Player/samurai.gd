extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var health = 100
@onready var anim = get_node("AnimatedSprite2D")
@export var is_alive = true
@export var attacking = false
@onready var sword_hitbox = $SwordHitBox #area for hitbox
@onready var hurtbox = $Hurtbox #area for hurtbox


func _ready() -> void:
	anim.sprite_frames.set_animation_loop("Attack", false) #prevents animation loop
	anim.sprite_frames.set_animation_loop("Die", false) #prevents animation loop
	anim.sprite_frames.set_animation_loop("Hit", false) #prevents animation loop
	sword_hitbox.monitoring = false #disable hitbox by default
	
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
	#var overlapping_objects = $SwordHit.get_overlapping_areas() #checks for everything in collision area, puts into list.
	#for area in overlapping_objects:
		#var parent = area.get_parent()
	if not attacking and is_alive:
		attacking = true #we have started to attack.
		sword_hitbox.monitoring = true # enable hitbox during attack so we can detect collisions
		anim.play("Attack") 
		await anim.animation_finished
		sword_hitbox.monitoring = false # disable hitbox again so it no longer detects collisions
		attacking = false
	
func take_damage(): #amount is always 20
	health -= 20
	print("Samurai health: ", health)
	if health <= 0:
		die()
	else:
		anim.play("Hit") #play hit animation to signifiy health loss.
		await anim.animation_finished
	
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

func _on_hurtbox_area_entered(area: Area2D) -> void: #when our hurtbox is entered by skeletons axe hitbox.
	if area.name == "AxeHitBox" and area.monitoring:
		print("Taking damage from axe")
		take_damage()
