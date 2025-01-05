extends Area2D

func _ready():
	body_entered.connect(_on_body_entered) #connect body_entered signal to our function.
	
func _on_body_entered(body):
	if body.name == "Samurai": #If we are the ones who fall off....
		body.die()
