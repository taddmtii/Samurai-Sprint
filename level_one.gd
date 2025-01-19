extends Node2D

#var skeleton_scene = preload("res://Skeleton.tscn")

#spawn skeleton on timer timeout
#func _on_timer_timeout() -> void:
	#var skeleton_instance = skeleton_scene.instantiate()
	#skeleton_instance.position = Vector2(randi_range(20, 500), -20)
	#add_child(skeleton_instance)

func _on_finish_sign_area_entered(area: Area2D) -> void:
	if area.name == "Samurai":
		get_tree().change_scene_to_file("res://level_completed.tscn")
