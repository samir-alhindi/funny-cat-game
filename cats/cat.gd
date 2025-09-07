class_name Cat extends Area2D

@export var points: int = 50
@export var sprites: SpriteFrames
@export var offset: Vector2 = Vector2(15, 20)
@export var speed: int

var dir: Vector2

static func new_cat(screen_size: Vector2) -> Cat:
	#var cat: Cat = preload("uid://cd8n8jsf0ilfd").instantiate()
	var cat: Cat = preload("uid://c7l4n5dhla5hh").instantiate()
	var offset := cat.offset
	cat.global_position = Vector2(
		randi_range(offset.x, screen_size.x-offset.x),
		randi_range(offset.y, screen_size.y-offset.y)
	)
	cat.dir = Vector2(
		randf_range(-1,1),
		randf_range(-1,1)).normalized()
	return cat

func _ready() -> void:
	%AnimatedSprite2D.sprite_frames = sprites
	%AnimatedSprite2D.play()
	get_window().title = "50 points"

func _physics_process(delta: float) -> void:
	global_position += dir * speed * delta
	
	var pos: Vector2 = global_position
	
	if pos.x + offset.x >= get_viewport_rect().size.x or pos.x - offset.x <= 0:
		dir.x *= -1
	if pos.y + offset.y >= get_viewport_rect().size.y or pos.y - offset.y <= 0:
		dir.y *= -1

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		on_click(event)

func on_click(event: InputEventMouseButton) -> void:
	%ClickSound.play()
	dir = Vector2.ZERO
	%CollisionShape2D.set_deferred("disabled", true)
	var score: RichTextLabel = preload("uid://buph56fg5yrwx").instantiate()
	add_child(score)
	score.global_position = Vector2(
		global_position.x - offset.x * 1.5,
		global_position.y - offset.y * 2 )
	var og_scale = %AnimatedSprite2D.scale
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(%AnimatedSprite2D, "scale", og_scale*1.5, 0.2)
	tween.tween_property(%AnimatedSprite2D, "scale", og_scale, 0.2)
	tween.set_parallel()
	tween.tween_property(%AnimatedSprite2D, "modulate:a", 0.0, 0.2)
	tween.tween_property(score, "modulate:a", 0.0, 0.2)
	tween.tween_property(score, "global_position", score.global_position - Vector2(0, 20), 0.2)
	await %ClickSound.finished
	Global.cat_clicked.emit(points)
	queue_free()
