extends Node2D
@export var enemy_scene: PackedScene
@export var enemy_count: int = 5
@export var spawn_delay: float = 2.0
var screen_size: Vector2
var alive: int = 0

func _ready():
	screen_size = get_viewport_rect().size
	spawn_loop()

func spawn_loop():
	while true:
		if not get_tree().paused and alive < enemy_count:
			var e = enemy_scene.instantiate()
			e.position = Vector2(randf_range(50, screen_size.x - 50), 50)
			add_child(e)
			alive += 1
		await get_tree().create_timer(spawn_delay, true).timeout

func enemy_killed():
	alive -= 1

func _input(_event):
	print("children: ", get_children())
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			$PauseMenu.resume()
		else:
			$PauseMenu.show_pause()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
