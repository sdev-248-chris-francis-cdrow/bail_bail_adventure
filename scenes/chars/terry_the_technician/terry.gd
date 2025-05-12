extends CharacterBody2D

var triggered = false
var has_attacked = false

func hurt() ->  void:
	if triggered:
		return
	triggered = true
	call_deferred("disable_and_hide")
	$AudioStreamPlayer2D.play()
	GameManager.score += 200
	await get_tree().create_timer(3).timeout
	call_deferred("queue_free")

func disable_and_hide() -> void:
	$Sprite2D.hide()
	$Toolbox/Toolbox.hide()
	$Toolbox/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("player") and not has_attacked:
			collision.get_collider().hurt()
			has_attacked = true
			print("hurt the player")
			break

func _on_timer_timeout() -> void:
	has_attacked = false
