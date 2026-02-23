extends Area2D

@export var horizontal_speed: float = 200.0
@export var float_speed: float = 60.0
@export var horizontal_duration: float = 0.6

var dir: int = 1          # 1 = right, -1 = left
var floating: bool = false
var h_timer: float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	$LifetimeTimer.timeout.connect(_on_lifetime_timeout)
	$LifetimeTimer.start()
	print("Timer wait time: ", $LifetimeTimer.wait_time)
	print("Timer started: ", not $LifetimeTimer.is_stopped())

@export var trapped_bubble_scene: PackedScene

func _on_body_entered(body):
	if body is CharacterBody2D:
		var trapped = trapped_bubble_scene.instantiate()
		trapped.position = body.position
		get_parent().add_child.call_deferred(trapped)
		get_node("/root/Main").enemy_killed()
		body.queue_free.call_deferred()
		queue_free.call_deferred()

func _physics_process(delta):
	if not floating:
		h_timer += delta
		position.x += dir * horizontal_speed * delta
		if h_timer >= horizontal_duration:
			floating = true
	else:
		position.y -= float_speed * delta
		if position.y < -50:
			queue_free()

func _on_lifetime_timeout():
	queue_free()
