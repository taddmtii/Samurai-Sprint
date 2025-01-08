extends Sprite2D

var player
@onready var timer = $Timer
#Cherry: Speed Boost
func _ready():
	player = get_node("../../Player/Samurai") 
	

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "CollisionArea":  #if samurai picks up powerup
		player.SPEED += 100.0 #increase speed
		print("New Speed: ", player.SPEED)
		print("Timer started")
		timer.start()
		self.visible = false
		#self.queue_free() 

func _on_timer_timeout() -> void:
	player.SPEED = 200.0
	print("Cherry powerup done! back to normal speed.")
	print("New Speed: ", player.SPEED)
