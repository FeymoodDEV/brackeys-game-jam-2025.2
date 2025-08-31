extends AudioStreamPlayer

signal bgm_changed(track: AudioStream)

func change_bgm(track: AudioStream) -> void:
	stream = track
	play()
