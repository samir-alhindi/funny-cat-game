class_name Main extends Node2D

var score: int = 0

func _ready() -> void:
	randomize()
	RenderingServer.set_default_clear_color(Color.BLACK)
	connect_signals()
	spawn_cat()

## For debugging.
func spawn_many_cats(amount: int) -> void:
	for i in range(amount):
		spawn_cat()

func connect_signals() -> void:
	Global.cat_clicked.connect(change_score)
	Global.add_window.connect(on_add_window)
	Global.play_window_sound.connect(func(): %WindowSound.play())

func spawn_cat() -> void:
	var cat := Cat.new_cat(get_viewport_rect().size, score)
	add_child(cat)

func change_score(amount: int) -> void:
	score += amount
	%Score.text = "[shake]score: %d" % score
	spawn_cat()

func _draw() -> void:
	var border := Rect2(Vector2.ZERO, get_viewport_rect().size)
	draw_rect(border, Color.WHITE, false, 1)

func on_add_window(window: Sprite2D, pos: Vector2) -> void:
	add_child(window)
	window.global_position = pos
