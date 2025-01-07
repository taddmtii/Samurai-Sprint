extends CharacterBody2D
@onready var anim = get_node("AnimatedSprite2D")
const SPEED = 50
var is_alive = true
var attacking = false
@onready var axe_hitbox = $AxeHitBox
@onready var hurtbox = $EnemyHurtbox
@export var health = 50
@export var damage = 20
var player #this is the samurai
var chase = false #active chase flag.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
 
func _ready():
	anim.sprite_frames.set_animation_loop("Attack", false) #prevents animation loop
	anim.sprite_frames.set_animation_loop("Death", false) #prevents animation loop
	anim.sprite_frames.set_animation_loop("Hit", false) #prevents animation loop
	#anim.play("Idle")
	axe_hitbox.monitoring = false
	#axe_hitbox.add_to_group("enemy_hitbox") #add hitbox to enemy hitbox.

func take_damage():
	health -= 20
	print("Skeleton health: ", health)
	if health <= 0:
		die()
	else:
		anim.play("Hit")
		await anim.animation_finished

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta #gravity for skeleton
	if chase == true:
		player = get_node("../../Player/Samurai") #get reference to player node.
		var direction = (player.position - self.position).normalized() #direction vector between enemy and player, normalized converts result to unit vector (-1 is left, 1 is right)
		#print(direction)
		if direction.x > 0: #player is right
			get_node("AnimatedSprite2D").flip_h = false
		else: #player is left
			get_node("AnimatedSprite2D").flip_h = true
		velocity.x = direction.x * SPEED #horizontal velocity towards player.
	else: #stop chasing, so skeleton shoudl stop moving
		velocity.x = 0 #stop movement
	update_animation()
	move_and_slide()
	
	if chase and player and is_alive and position.distance_to(player.position) < 30:
		attack()

func attack():
	if not attacking and is_alive:
		attacking = true
		anim.play("Attack")
		axe_hitbox.monitoring = true
		await anim.animation_finished
		axe_hitbox.monitoring = false
		attacking = false

func update_animation(): #Handles all move and jump animation logic.
	if is_alive:
		if !attacking: #as long as we are not attacking
			if velocity.x != 0: #if we are not idle
				anim.play("Walk")
			else:
				anim.play("Idle")
				
func die():
	is_alive = false
	attacking = false
	chase = false
	velocity = Vector2.ZERO
	axe_hitbox.monitoring = false
	#hurtbox.monitorable = false
	#set_deferred("monitorable", false)
	anim.play("Death")
	await anim.animation_finished
	queue_free()

#if skelton falls off map
func _on_death_wall_body_entered(body: Node2D) -> void:
	if body.name == "Skeleton": #If we are the ones who fall off....
		body.die()
	
#DETECTION FOR CHASE
func _on_player_detection_body_entered(body: Node2D) -> void: # if the player enters the detection circle for the skelton...
	if body.name == "Samurai":
		chase = true #player detected, lets chase.

func _on_player_detection_body_exited(body: Node2D) -> void: #if player exits detection circle...
	if body.name == "Samurai":
		chase = false #player not detected anymore, stop chase.

#Logic for hurtbox
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "SwordHitBox" and area.monitoring:
		take_damage()
