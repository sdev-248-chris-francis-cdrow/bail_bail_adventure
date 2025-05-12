extends CanvasLayer

var has_loaded:bool = false
@onready var DialogLabel: Label = $Label
var dialog: Array[String] = [
	"Bail, Bail you silly girl,",
	" Did you lose your 3 favorite balls again?",
	" Well, you'll have to go and look for them yourself.",
	" Mommy has to go and lay down. Be safe, Sweetie!"
]




func _on_button_pressed() -> void:
	load_next_level()


func load_next_level() -> void:
	if has_loaded == false:
		GameManager.level_loader(GameManager.current_level + 1)
		GameManager.current_level += 1 



func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()

func _ready() -> void:
	MusicPlayer.play_if_not_playing("res://assets/music/floating-cat-michael-grubb-main-version-24551-01-53.mp3")

var dialog_index := 0
func _on_dialog_timer_timeout() -> void:
	if dialog_index < dialog.size():
		DialogLabel.text += dialog[dialog_index]
		dialog_index += 1
		if dialog_index == 1:
			$Dialog.show()
	else:
		$DialogTimer.stop()
		await get_tree().create_timer(5).timeout
		load_next_level()
