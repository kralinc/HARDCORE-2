extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("shrink")
	texture = Globals.fatal_frame

