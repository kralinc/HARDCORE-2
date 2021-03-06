extends AudioStreamPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	if stream.resource_path != Globals.previous_music:
		Globals.previous_music = stream.resource_path
		Globals.music_playhead = 0.0
	self.play(Globals.music_playhead)


func _process(delta):
	if Globals.music_playhead + delta > stream.get_length():
		Globals.music_playhead = stream.get_length() + delta - Globals.music_playhead
	else:
		Globals.music_playhead += delta
