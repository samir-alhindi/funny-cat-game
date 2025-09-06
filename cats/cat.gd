class_name Cat extends Area2D

var data: CatData
var dir: Vector2
var speed: int
var offset: Vector2

static func new_cat(screen_size: Vector2) -> Cat:
	var cat: Cat = preload("uid://bqvvdn25jdm0u").instantiate()
	cat.data = preload("uid://djhnepe2yk58y")
	var offset := cat.data.offset
	cat.global_position = Vector2(
		randi_range(offset.x, screen_size.x-offset.x),
		randi_range(offset.y, screen_size.y-offset.y)
	)
	cat.offset = offset
	cat.dir = Vector2(
		randf_range(-1,1),
		randf_range(-1,1)).normalized()
	cat.speed = 200
	return cat

func _ready() -> void:
	%AnimatedSprite2D.sprite_frames = data.sprites
	%AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	global_position += dir * speed * delta
	
	var pos: Vector2 = global_position
	
	if pos.x + offset.x >= get_viewport_rect().size.x or pos.x - offset.x <= 0:
		dir.x *= -1
	if pos.y + offset.y >= get_viewport_rect().size.y or pos.y - offset.y <= 0:
		dir.y *= -1
