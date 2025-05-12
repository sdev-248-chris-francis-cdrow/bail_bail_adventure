extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$EatApple.play()
		$Sprite2D.visible = false
		if GameManager.player_health <= 2:
			GameManager.player_health += 1
			body.set_life(GameManager.player_health)
			await get_tree().create_timer(2).timeout
			queue_free()
		else:
			await get_tree().create_timer(2).timeout
			queue_free()
