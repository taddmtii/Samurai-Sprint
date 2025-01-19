extends Control

#var player
var overall_score
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stats = get_tree().get_meta("level_stats")
	#player = get_node("../Player/Samurai") #get reference to player node.
	overall_score = int(stats.gems * 200) + int(stats.skeletons * 50)
	$"Title Screen/MarginContainer/VBoxContainer/Gems".text = "Gems: " + str(stats.gems)
	$"Title Screen/MarginContainer/VBoxContainer/Skeletons Killed".text = "Skeletons Killed: " + str(stats.skeletons)
	$"Title Screen/MarginContainer/VBoxContainer/Overall Score".text = "Overall Score: " + str(overall_score)
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://level_one.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
