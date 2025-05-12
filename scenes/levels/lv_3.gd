extends Node2D

func _ready() -> void:
	MusicPlayer.play_if_not_playing("res://assets/music/threshold-michael-grubb-main-version-25748-02-03.mp3")


func _on_black_squirrel_3_awaken_the_king() -> void:
	$Dialog.show()
	await get_tree().create_timer(5).timeout
	call_deferred("unleash_the_munk")
	
func unleash_the_munk() -> void:
	await get_tree().create_timer(0.1).timeout
	$Chippy.show()
	$Chippy/CollisionShape2D.disabled = false
	$Chippy.disabled = false
	$Dialog.hide()
	
