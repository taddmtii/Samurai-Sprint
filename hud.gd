extends Control

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../../") #get reference to player node.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Panel/Health.text = "Health: " + str(player.health)
	$Panel/Gems.text = "Gems: " + str(player.gem_count)
	$Panel/SkeletonsKilled.text = "Skeletons Killed: " + str(player.skeletons_killed)
