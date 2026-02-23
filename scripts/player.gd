extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const GRAVITY = 900.0  # pixels/sec²

@export var bubble_scene: PackedScene
@export var max_bubbles: int = 10

var facing: int = 1  # 1 = right, -1 = left
var active_bubbles: int = 0

func _ready():
	$lives_check.body_entered.connect(_on_enemy_touched)

func _on_enemy_touched(body):
	if body is CharacterBody2D:
		get_node("/root/Main/Lives").lose_life()

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * SPEED
		facing = int(sign(direction))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Shoot bubble
	if Input.is_action_just_pressed("fire") and active_bubbles < max_bubbles:
		_shoot_bubble()

	# Screen wrapping
	var screen = get_viewport_rect().size
	if global_position.x > screen.x:
		global_position.x = 0
	elif global_position.x < 0:
		global_position.x = screen.x
	if global_position.y > screen.y:
		global_position.y = 0
	elif global_position.y < 0:
		global_position.y = screen.y
	# Move & slide along TileMap collisions
	move_and_slide()

func _shoot_bubble():
	var b = bubble_scene.instantiate()
	b.position = global_position + Vector2(facing * 20, 0)
	b.dir = facing
	b.tree_exited.connect(_on_bubble_removed)
	active_bubbles += 1
	get_parent().add_child(b)

func _on_bubble_removed():
	active_bubbles -= 1
