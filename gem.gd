extends Sprite2D

var player

#Gems: player score, or currency.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../../Player/Samurai") 

func _on_gem_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Samurai":
		player.gem_count += 1
		print("Gem picked up! New player gem count: ", player.gem_count)
		self.queue_free()
