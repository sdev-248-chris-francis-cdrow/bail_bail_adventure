extends CanvasLayer

var has_loaded:bool = false
@onready var DialogLabel: Label = $Label
var dialog: Array[String] = [
	"Good girl Bailey, you found your balls!",
	" You didnt get into any trouble while",
	" I was laying down and resting did you?",
	" Oh well, lets go to bed."
]




func _on_button_pressed() -> void:
	load_next_level()


func load_next_level() -> void:
	if has_loaded == false:
		GameManager.level_loader(0)
		GameManager.current_level = 0



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
