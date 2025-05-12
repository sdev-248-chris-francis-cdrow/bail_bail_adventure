extends CanvasLayer

func _ready() -> void:
	MusicPlayer.stop_music()
func _on_main_menu_button_pressed() -> void:
	GameManager.current_level = 0
	GameManager.level_loader(0)
