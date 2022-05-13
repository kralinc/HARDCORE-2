extends Control

func _ready():
	$RetryButton.grab_focus()



func _on_RetryButton_pressed():
	Globals.new_scene = true
	Globals.previous_music = ""
	get_tree().change_scene("res://environment/level1/level1.tscn")


func _on_QuitButton_pressed():
	get_tree().change_scene("res://mainmenu.tscn")


func _on_RetryButton_focus_exited():
	$SoundEffect.play()


func _on_QuitButton_focus_exited():
	$SoundEffect.play()
