extends ParallaxBackground


var scrolling_speed = 100

func _process(delta: float) -> void:
	scroll_offset.x -= scrolling_speed * delta # send offset to the left.

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
