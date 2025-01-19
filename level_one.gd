extends Node2D

#var skeleton_scene = preload("res://Skeleton.tscn")

#spawn skeleton on timer timeout
#func _on_timer_timeout() -> void:
	#var skeleton_instance = skeleton_scene.instantiate()
	#skeleton_instance.position = Vector2(randi_range(20, 500), -20)
	#add_child(skeleton_instance)


func _on_finish_sign_body_entered(body: Node2D) -> void:
		if body.name == "Samurai":
			var stats = {
				"health": body.health,
				"gems": body.gem_count,
				"skeletons": body.skeletons_killed
			}
			get_tree().set_meta("level_stats", stats)
			get_tree().call_deferred("change_scene_to_file", "res://level_completed.tscn")

		
