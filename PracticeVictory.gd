extends Control

func _ready():
	$Button.grab_focus()
	$DeathsLabel.text = "You died " + str(99 - Globals.lives) + " times to get here!"


func _on_Button_pressed():
	get_tree().change_scene("res://mainmenu.tscn")
