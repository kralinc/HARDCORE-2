extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Fader/AnimationPlayer.play("fadein")

func _input(e):
	if e.is_action_pressed("pause"):
		get_tree().change_scene("res://mainmenu.tscn")

func _on_Timer_timeout():
	$Scroll.play("scroll")
	$MenuTimer.start()


func _on_MenuTimer_timeout():
	$Fader/AnimationPlayer.play("fadeout")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadeout":
		get_tree().change_scene("res://mainmenu.tscn")
