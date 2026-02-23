extends Area2D

@export var float_speed: float = 80.0
@export var wait_duration: float = 2.5
var floating: bool = true
var target_x: float
var target_y: float = 50.0
var timer: float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	target_x = get_viewport_rect().size.x / 2.0

func _process(delta):
	if floating:
		position.y = move_toward(position.y, target_y, float_speed * delta)
		position.x = move_toward(position.x, target_x, float_speed * delta)
		if position.y <= target_y + 1:
			floating = false
	else:
		timer += delta
		if timer >= wait_duration:
			queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		get_node("/root/Main/Lives").add_score()
		queue_free()
