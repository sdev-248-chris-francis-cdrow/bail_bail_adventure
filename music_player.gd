extends Node

# Persistent audio player and state
var player := AudioStreamPlayer.new()
var music_position: float = 0.0

func _ready() -> void:
	# Set the player to use the "Music" audio bus and add to this node
	player.bus = "Music"
	add_child(player)

# Sets a new music stream and plays it (resumes if specified)
func set_stream(stream: AudioStream, resume: bool = false) -> void:
	player.stream = stream
	if resume:
		player.play(music_position)
	else:
		player.play()
		
# Plays the given music file if it's not already playing
func play_if_not_playing(path: String, resume: bool = false) -> void:
	if player.stream is AudioStream and player.stream.resource_path == path and player.playing:
		return # Already playing the correct track

	stop_music()  # Save position and stop current
	var new_stream := load(path)
	set_stream(new_stream, resume)
	
# Stops the music and saves the current playback position
func stop_music() -> void:
	if player.playing:
		music_position = player.get_playback_position()
		player.stop()

# Resumes playback from the last known position
func resume_music() -> void:
	if not player.playing and player.stream:
		player.play(music_position)
