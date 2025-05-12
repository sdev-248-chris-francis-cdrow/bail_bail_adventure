extends CharacterBody2D

signal awaken_the_king

@export var speed: float = 45  # Speed of the enemy
@onready var sprite = $BlackSquirrel
@onready var left_ray = $LeftRay  # Left-facing ray
@onready var right_ray = $RightRay  # Right-facing ray
@export var has_ball:bool = false
@export var is_summoner:bool = false
var triggered = false
var direction: int = -1  # -1 = left, 1 = right

func _physics_process(delta):
	if triggered:
		return
	# Move enemy left or right
	velocity.x = direction * speed
	
		# Check for collision using raycasts
	if left_ray.is_colliding() and direction == -1:
		flip_direction()
	elif right_ray.is_colliding() and direction == 1:
		flip_direction()

		
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("player"):  # Detect player collision
			collision.get_collider().hurt()  # Call the hurt function on the player
			break  # Stop checking once the player is hit
			


func flip_direction() -> void:
	direction *= -1  # Reverse direction
	sprite.flip_h = !sprite.flip_h  # Flip sprite horizontally

func dhuap() -> void: #disable hide update and play
	$BlackSquirrel.hide()
	$CollisionShape2D.disabled = true
	GameManager.score += 200
	$AudioStreamPlayer2D.play()
	if has_ball:
		$Ball.monitoring = true
		$Ball.show()
	if is_summoner:
		awaken_the_king.emit()
func hurt() ->  void:
	if triggered:
		return
	triggered = true
	call_deferred("dhuap")
	if not has_ball:
		await get_tree().create_timer(3).timeout
		call_deferred("queue_free")
