extends CharacterBody2D

const GRAVITY = 900.0
@export var speed: float = 150.0

var direction: int = 1
var landed: bool = false

func _ready():
	direction = [-1, 1].pick_random()
	print("Enemy collision layer: ", collision_layer)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		# Drift toward center-bottom while falling
		var screen_center_x = get_viewport_rect().size.x / 2.0
		velocity.x = move_toward(velocity.x, sign(screen_center_x - global_position.x) * speed, speed * delta)
	else:
		# Once landed, start patrolling normally
		landed = true

	if landed:
		$LedgeDetector.target_position.x = abs($LedgeDetector.target_position.x) * direction

		if is_on_wall() or not $LedgeDetector.is_colliding():
			direction *= -1
			$Sprite2D.flip_h = direction == -1

		velocity.x = direction * speed

	move_and_slide()
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider().name == "Player":
			print("Player hit!")
			get_node("/root/Main/Lives").lose_life()
			
