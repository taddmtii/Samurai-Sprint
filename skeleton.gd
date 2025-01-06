extends CharacterBody2D
@onready var anim = get_node("AnimatedSprite2D")


const SPEED = 50

var is_alive = true
var attacking = false
var player #this is the samurai
var chase = false #active chase flag.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
 
func _ready():
	anim.play("Idle")

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

func update_animation(): #Handles all move and jump animation logic.
	if is_alive:
		if !attacking: #as long as we are not attacking
			if velocity.x != 0: #if we are not idle
				anim.play("Walk")
			else:
				anim.play("Idle")
				
func die():
	is_alive = false
	velocity = Vector2.ZERO
	anim.play("Die")
	await anim.animation_finished


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
