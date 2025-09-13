extends Cat

func on_click() -> void:
	%Anim.stop()
	%AngelCatEffect.queue_free()
	super.on_click()
	spawn_window()
