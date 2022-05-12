extends Control

func _ready():
	$RetryButton.grab_focus()



func _on_RetryButton_pressed():
	if Globals.hardcore:
		Globals.lives = 1
	else:
		Globals.lives = 99
	Globals.new_scene = true
	Globals.previous_music = ""
	get_tree().change_scene("res://environment/level1/level1.tscn")


func _on_QuitButton_pressed():
	get_tree().change_scene("res://mainmenu.tscn")
