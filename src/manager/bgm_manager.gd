extends AudioStreamPlayer

signal change_bgm(track: AudioStream)

func _on_change_bgm(track: AudioStream) -> void:
	stream = track
	play()
