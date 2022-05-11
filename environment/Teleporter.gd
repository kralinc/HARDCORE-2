extends AnimatedSprite

signal teleporting

export var NEXT_SCENE = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	play()
	if Globals.new_scene:
		$Fader.play("fadein")
		Globals.new_scene = false
	else:
		$Canvas/Fade.color.a = 0


func _on_Area2D_body_entered(body):
	$TeleportSound.play()
	$Fader.play("fadeout")


func _on_Fader_animation_finished(anim_name):
	if anim_name == "fadeout":
		Globals.new_scene = true
		get_tree().change_scene(NEXT_SCENE)
