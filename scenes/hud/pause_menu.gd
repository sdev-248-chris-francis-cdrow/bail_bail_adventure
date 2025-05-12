extends CanvasLayer

@onready var menu := $PopupMenu

func _ready() -> void:
	# Manually set size and position
	menu.set_position(Vector2(100, 100))  # Adjust to center if needed
	menu.set_size(Vector2(400, 400))      # Force size

	menu.clear()
	menu.add_item("Resume", 0)
	menu.add_item("Save", 1)
	menu.add_item("Main Menu", 2)

	
	
	

func _process(_delta: float) -> void:
		if menu.visible:
			get_tree().paused = true
		else:
			get_tree().paused = false
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		menu.popup_centered()

func _on_menu_item_pressed(id):
	match id:
		0:
			print("Resume")
			menu.hide()
			get_tree().paused = false  # Resume the game
		1:
			print("Save")
			get_tree().paused = false
			GameManager.save_game_data()
			
		2:
			print("Main Menu")
			get_tree().paused = false  # Unpause before switching scenes
			GameManager.level_loader(0)
