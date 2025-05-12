extends CanvasLayer

func  _ready() -> void:
	MusicPlayer.play_if_not_playing("res://assets/music/floating-cat-michael-grubb-main-version-24551-01-53.mp3")
func _on_quit_game_pressed() -> void:
	if OS.get_name() != "HTML5":
		get_tree().quit()

func _on_load_game_pressed() -> void:
	if not FileAccess.file_exists("user://save.json"):
		print("No save file found.")
		$PopupMenu.popup()
		return

	var file = FileAccess.open("user://save.json", FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()

	var data = JSON.parse_string(json_text)
	if data is Dictionary:
		GameManager.current_level = data.get("current_level", 1)
		GameManager.player_health = data.get("player_health", 3)
		GameManager.score = data.get("score", 0)
	else:
		print("Error parsing save file.")
	
	GameManager.level_loader(GameManager.current_level)
		

			
func _on_popupbutton_pressed() -> void:
	$PopupMenu.hide()


func _on_new_game_pressed() -> void:
	GameManager.current_level = 1
	GameManager.player_health = 3
	GameManager.score = 0
	GameManager.level_loader(1)


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
