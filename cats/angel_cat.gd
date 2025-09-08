extends Cat

func on_click(event: InputEventMouseButton) -> void:
	%Anim.stop()
	%AngelCatEffect.queue_free()
	super.on_click(event)
	spawn_window()
