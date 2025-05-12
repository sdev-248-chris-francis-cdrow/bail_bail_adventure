extends CharacterBody2D

signal life_changed
signal died


@export var gravity = 800
@export var run_speed = 150
@export var jump_speed = -450


enum {IDLE, RUN, JUMP, HURT, DEAD, WIN, ATTACK}
var state = IDLE
var last_floor = false
var jump_count = 1
var last_going_right = true


func _ready():
	change_state(IDLE)
	set_life(GameManager.player_health)

func reset(_position):
	position = _position
	show()
	change_state(IDLE)
	set_life(GameManager.player_max_health)
	
func hurt() -> void:
	if state != HURT:
		$HurtSound.play()
		change_state(HURT)

func set_life(value):
	GameManager.player_health = value
	life_changed.emit(GameManager.player_health)
func die() -> void:
	if state != DEAD:
		change_state(DEAD)
		
func win() -> void:
	if state not in [HURT, DEAD, WIN]:
		change_state(WIN)


func get_input() -> void:
	if state == HURT:
		return  # don't allow movement during hurt state
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	var _up = Input.is_action_pressed("up")
	var _down = Input.is_action_pressed("down")
	var attack = Input.is_action_pressed("attack")

	# movement occurs in all states
	velocity.x = 0
	
		
	if right:
		velocity.x += run_speed
		$AnimatedSprite2D.flip_h = false
		last_going_right = true
	if left:
		velocity.x -= run_speed
		$AnimatedSprite2D.flip_h = true
		last_going_right = false
	
	# Handle attack input (should trigger ATTACK state)
	if attack and state != ATTACK:
		change_state(ATTACK)

	# only allow jumping when on the ground
	if jump and is_on_floor():
		$AnimatedSprite2D.play("jump")
		$JumpSound.play()
		change_state(JUMP)
		velocity.y = jump_speed
	# IDLE transitions to RUN when moving
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	# RUN transitions to IDLE when standing still
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	# transition to JUMP when in the air
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
	
	
func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimatedSprite2D.play("idle")
		RUN:
			$AnimatedSprite2D.play("walk")
		HURT:
			velocity.y = -200
			if last_going_right:
				velocity.x = -200
			else:
				velocity.x = 200
			set_life(GameManager.player_health - 1)
			await get_tree().create_timer(0.5).timeout
			change_state(IDLE)
			if GameManager.player_health <= 0:
				change_state(DEAD)
		JUMP:
			jump_count = 1
		ATTACK:
			$BarkBox/CollisionShape2D2.disabled = false
			$BarkSound.play()
			$AnimatedSprite2D.play("attack")
			await get_tree().create_timer(0.4).timeout
			$BarkBox/CollisionShape2D2.disabled = true
			
			# After attack animation is finished, check for movement or idle state.
			if velocity.length() > 0:
				change_state(RUN)
			else:
				change_state(IDLE)
		DEAD:
			$CollisionShape2D.disabled = true
			died.emit()
			hide()
			await get_tree().create_timer(2).timeout
			GameManager.level_loader(6)
			$CollisionShape2D.disabled = false
		WIN:
			$CollisionShape2D.disabled = true
			hide()
			await get_tree().create_timer(2).timeout
			GameManager.level_loader(5)
			$CollisionShape2D.disabled = false
			
			
func _physics_process(delta) -> void:	
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
	if state == HURT:
		return
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var _collider = collision.get_collider()
		if collision.get_collider().is_in_group("danger"):
			hurt()
		if collision.get_collider().is_in_group("enemies"):
			hurt()
	
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		jump_count = 0
	last_floor = is_on_floor()

var attack_triggered = false
func _on_bark_box_body_entered(body: Node2D) -> void:
	if attack_triggered:
		return
	if body.is_in_group("enemies"):
		attack_triggered = true
		body.hurt()
		attack_triggered = false
