extends Area2D

var has_loaded:bool = false

func load_next_level() -> void:
	if has_loaded == false:
		GameManager.level_loader(GameManager.current_level + 1)
		GameManager.current_level += 1 
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		call_deferred("load_next_level")
