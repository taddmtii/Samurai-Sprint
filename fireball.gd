extends Sprite2D


var player
@onready var timer = $Timer
@onready var fireball_hitbox = $FireballHitbox

#Fireball: Increased jump height
func _ready():
	player = get_node("../../Player/Samurai") 

func _on_fireball_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Samurai":
		player.JUMP_VELOCITY = -450.0
		print("Player has increased jump now for 10 seconds")
		timer.start()
		self.visible = false
		fireball_hitbox.set_deferred("monitoring", false)


func _on_timer_timeout() -> void:
	player.JUMP_VELOCITY = -350.0
	print("Timer timeout")
	self.queue_free()
