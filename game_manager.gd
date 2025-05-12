extends Node

var current_level: int
var player_health: int
var player_max_health: int = 3
var score: int


func level_loader(level: int) -> void:
	var level_scenes := {
		0: "res://scenes/hud/main_menu.tscn",
		1: "res://scenes/hud/opening_cutscene.tscn",
		2: "res://scenes/levels/lv1.tscn",
		3: "res://scenes/levels/lv2.tscn",
		4: "res://scenes/levels/lv3.tscn",
		5: "res://scenes/hud/ending_cutscene.tscn",
		6: "res://scenes/hud/game_over.tscn"
	}

	if not level_scenes.has(level):
		push_error("Invalid level: %s" % level)
		return

	var path: String = level_scenes[level]
	if not ResourceLoader.exists(path):
		push_error("Scene file does not exist: %s" % path)
		return

	get_tree().change_scene_to_file(path)

func save_data(data: Dictionary, file_path: String = "user://save.json") -> void:
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	
	if file == null:
		push_error("Failed to open file for writing: %s" % file_path)
		return
	
	var json_string := JSON.stringify(data)
	file.store_string(json_string)
	file.close()
		
func save_game_data() -> void:
	var game_data = {
		"current_level": current_level,
		"score": score,
		"player_health": player_health
	}
	
	save_data(game_data)
