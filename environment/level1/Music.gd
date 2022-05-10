extends AudioStreamPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	self.play(Globals.music_playhead)
	pass


func _process(delta):
	if Globals.music_playhead + delta > stream.get_length():
		Globals.music_playhead = stream.get_length() + delta - Globals.music_playhead
	else:
		Globals.music_playhead += delta
