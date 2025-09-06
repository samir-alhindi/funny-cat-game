class_name Main extends Node2D

var score: int = 0

func _ready() -> void:
	randomize()
	RenderingServer.set_default_clear_color(Color.BLACK)
	Global.cat_clicked.connect(change_score)
	spawn_cat()

func spawn_cat() -> void:
	var cat := Cat.new_cat(get_viewport_rect().size)
	add_child(cat)

func change_score(amount: int) -> void:
	score += amount
	%Score.text = "[shake]score: %d" % score
	spawn_cat()

func _draw() -> void:
	var border := Rect2(Vector2.ZERO, get_viewport_rect().size)
	draw_rect(border, Color.WHITE, false, 1)
