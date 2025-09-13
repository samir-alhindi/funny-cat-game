extends Cat

func _ready() -> void:
	self.global_position = get_viewport_rect().size / 2
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2(1,1) * 6, 1)
	await tween.finished
	get_tree().quit(0)

func _physics_process(_delta: float) -> void:
	pass
