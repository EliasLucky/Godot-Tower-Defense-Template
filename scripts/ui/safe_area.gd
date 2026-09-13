extends MarginContainer

func _ready() -> void:
	get_tree().get_root().size_changed.connect(_update_safe_area)
	
	_update_safe_area()

func _update_safe_area() -> void:
	var safe_area: Rect2 = DisplayServer.get_display_safe_area()
	
	var window_size: Vector2i = DisplayServer.window_get_size()
	
	var margin_top: int = int(safe_area.position.y)
	@warning_ignore("unused_variable")
	var margin_left: int = int(safe_area.position.x)
	@warning_ignore("unused_variable")
	var margin_bottom: int = window_size.y - int(safe_area.end.y)
	@warning_ignore("unused_variable")
	var margin_right: int = window_size.x - int(safe_area.end.x)
	
	add_theme_constant_override("margin_top", margin_top)
	#add_theme_constant_override("margin_left", margin_left)
	#add_theme_constant_override("margin_bottom", margin_bottom)
	#add_theme_constant_override("margin_right", margin_right)
