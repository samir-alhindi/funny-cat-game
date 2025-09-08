extends Sprite2D

func _ready() -> void:
	modulate.a = 0.0
	await toggle_visibility(1.0, 0.25)
	%CollisionShape2D.call_deferred("set_disabled", false)
	await get_tree().create_timer(2.0).timeout
	await toggle_visibility(0.0, 0.25)
	queue_free()

func toggle_visibility(final_val: float, time: float) -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", final_val, time)
	await tween.finished

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		%CollisionShape2D.call_deferred("set_disabled", true)
		Global.play_window_sound.emit()
