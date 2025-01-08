extends Sprite2D

var player

#Acorn: All health back
func _ready():
	player = get_node("../../Player/Samurai") 

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "SwordHitBox":  #if samurai picks up powerup
		player.health = 100 #increase speed
		player.HealthBar.value = 100
		self.queue_free() 
