extends Sprite2D

var player
@onready var timer = $Timer
@onready var hitbox = $Hitbox
#Cherry: Speed Boost
func _ready():
	player = get_node("../../Player/Samurai") 

func _on_timer_timeout() -> void:
	player.SPEED = 200.0
	player.cherry_active = false
	print("Timer timeout")
	self.queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Samurai":
		print("Picked up cherry")
		player.SPEED = 300.0 #increase speed
		player.cherry_active = true
		print("new speed: ", player.SPEED)
		timer.start()
		self.visible = false
		hitbox.set_deferred("monitoring", false)
