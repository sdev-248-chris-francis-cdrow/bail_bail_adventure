extends CanvasLayer


func _process(_delta: float) -> void:
	update_hud()

func update_hud() -> void:
	update_health(GameManager.player_health)
	update_score(GameManager.score)
	update_level(GameManager.current_level)
	
func update_score(score:int) -> void:
	$Label.text = str(score).pad_zeros(4)
	
func update_level(level:int) -> void:
	if level == 3:
		$Ball.show()
		$Ball2.hide()
		$Ball3.hide()
	elif level == 4:
		$Ball.show()
		$Ball2.show()
		$Ball3.hide()
	else:
		$Ball.hide()
		$Ball2.hide()
		$Ball3.hide()
		
func update_health(health: int) -> void:
	reset_health_gui()
	
	if health < 0 or health > 3:
		print(health)
		return
	# Full and Empty heart nodes
	var full_hearts = [$HeartFull, $HeartFull2, $HeartFull3]
	var empty_hearts = [$HeartEmpty3, $HeartEmpty2, $HeartEmpty]
	
	# Set the number of full hearts visible
	for i in range(health):
		full_hearts[i].visible = true

	# Set the number of empty hearts visible (the rest)
	for i in range(3 - health):
		empty_hearts[i].visible = true
	
func reset_health_gui() -> void:
	var full_hearts = [$HeartFull, $HeartFull2, $HeartFull3]
	var empty_hearts = [$HeartEmpty3, $HeartEmpty2, $HeartEmpty]

	for node in full_hearts + empty_hearts:
		node.visible = false
