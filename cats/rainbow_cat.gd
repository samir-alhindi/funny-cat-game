extends Cat

func on_click(event: InputEventMouseButton) -> void:
	%Anim.stop()
	%RainbowCatEffect.queue_free()
	super.on_click(event)
