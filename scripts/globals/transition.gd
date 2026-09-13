extends CanvasLayer

var _overlay : ColorRect
var _active : bool = false

func _ready() -> void:
	layer = 100 
	_overlay = ColorRect.new()
	_overlay.color = Color(0,0,0,0)  
	_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_overlay)

func transition_to_scene(path : String, dur : float = 0.4) -> void:
	if _active: return
	_active = true
	
	var tw := create_tween()
	tw.tween_property(_overlay, "color:a", 1.0, dur)
	tw.tween_callback(func(): get_tree().change_scene_to_file(path))
	tw.tween_interval(0.1)
	tw.tween_property(_overlay, "color:a", 0.0,dur)
	tw.tween_callback(func(): _active = false)
