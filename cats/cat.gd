class_name Cat extends Area2D

@export var points: int = 50
@export var sprites: SpriteFrames
@export var offset: Vector2 = Vector2(15, 20)
@export var speed: int = 100

var dir: Vector2

static func new_cat(screen_size: Vector2, score: int) -> Cat:
	var cat_scene: PackedScene = get_cat_scene(score)
	var cat: Cat = cat_scene.instantiate()
	var offset := cat.offset
	cat.global_position = Vector2(
		randi_range(offset.x, screen_size.x-offset.x),
		randi_range(offset.y, screen_size.y-offset.y)
	)
	cat.dir = Vector2(
		randf_range(-1,1),
		randf_range(-1,1)).normalized()
	return cat

static func get_cat_scene(score: int) -> PackedScene:
	var num := randf()
	if num <= .25:
		return preload("uid://bh4760nkbyug6") # Angel cat
	elif num <= .50:
		return preload("uid://p2eg64ri5mi1") # Rainbow cat
	elif num <= .75:
		return preload("uid://c7l4n5dhla5hh") # Blue Aura cat
	else:
		return preload("uid://cd8n8jsf0ilfd") # Normal cat
	

func _ready() -> void:
	%AnimatedSprite2D.sprite_frames = sprites
	%AnimatedSprite2D.play()
	get_window().title = "50 points"

func _physics_process(delta: float) -> void:
	global_position += dir * speed * delta
	
	var pos: Vector2 = global_position
	
	if pos.x + offset.x > get_viewport_rect().size.x or pos.x - offset.x < 0:
		dir.x *= -1
	if pos.y + offset.y > get_viewport_rect().size.y or pos.y - offset.y < 0:
		dir.y *= -1

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		on_click(event)

func on_click(event: InputEventMouseButton) -> void:
	%ClickSound.play()
	dir = Vector2.ZERO
	%CollisionShape2D.set_deferred("disabled", true)
	
	var score_label: RichTextLabel = preload("uid://buph56fg5yrwx").instantiate()
	score_label.text = "+%d" % points
	add_child(score_label)
	var label_x_pos := global_position.x - offset.x
	var label_y_pos := global_position.y + ( - offset.y * 2.5 # Spawn above cat
		if global_position.y > get_viewport_rect().size.y / 2 # Is cat in the upper half of screen or lower ?
		else offset.y * 2) # Spawn label below cat
	score_label.global_position = Vector2(label_x_pos, label_y_pos)
	
	var og_scale = %AnimatedSprite2D.scale
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(%AnimatedSprite2D, "scale", og_scale*1.5, 0.2)
	tween.tween_property(%AnimatedSprite2D, "scale", og_scale, 0.2)
	tween.set_parallel()
	tween.tween_property(%AnimatedSprite2D, "modulate:a", 0.0, 0.2)
	tween.tween_property(score_label, "modulate:a", 0.0, 0.2)
	tween.tween_property(score_label, "global_position", score_label.global_position - Vector2(0, 20), 0.2)
	await %ClickSound.finished
	Global.cat_clicked.emit(points)
	queue_free()

func spawn_window() -> void:
	var window: Sprite2D = preload("uid://c16bg7bkunapy").instantiate()
	Global.add_window.emit(window, self.global_position)
