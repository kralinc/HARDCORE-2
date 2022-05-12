extends Control

##########
#
# Avert your eyes before they melt
#
##########

var controls_menu = false
var keyboard_controls = false

func _ready():
	$Main/PracticeButton.grab_focus()
	
func _input(e):
	if controls_menu and e.is_action_pressed("ui_left") or e.is_action_pressed("ui_right"):
		keyboard_controls = !keyboard_controls
		$Controls/KeyboardStuff.visible = !$Controls/KeyboardStuff.visible
		$Controls/ControllerStuff.visible = !$Controls/ControllerStuff.visible
		if $Controls/Label.text.begins_with("< K"):
			$Controls/Label.text = "< Controller >"
		else:
			$Controls/Label.text = "< Keyboard >"
			
	if controls_menu and e.is_action_pressed("ui_cancel"):
		_on_BackButton_pressed()
		
	if e.is_action_pressed("funny"):
		get_tree().change_scene("res://DEV.tscn")


func _on_HardcoreButton_pressed():
	Globals.hardcore = true
	Globals.lives = 1
	reset_globals()
	get_tree().change_scene("res://environment/level1/level1.tscn")


func _on_PracticeButton_pressed():
	Globals.hardcore = false
	Globals.lives = 99
	reset_globals()
	get_tree().change_scene("res://environment/level1/level1.tscn")
	
func reset_globals():
	Globals.previous_music = ""
	Globals.new_scene = true
	Globals.music_playhead = 0.0


func _on_ControlsButton_pressed():
	$Main.visible = false
	$Controls.visible = true
	$Controls/AltControls.grab_focus()
	controls_menu = true


func _on_BackButton_pressed():
	$Main.visible = true
	$Controls.visible = false
	$Main/PracticeButton.grab_focus()
	controls_menu = false


func _on_AltControls_pressed():
		$Controls/KeyboardStuff/RegularControls.visible = !$Controls/KeyboardStuff/RegularControls.visible
		$Controls/KeyboardStuff/AltControls.visible = !$Controls/KeyboardStuff/AltControls.visible
		
		$Controls/ControllerStuff/RegularControls.visible = !$Controls/ControllerStuff/RegularControls.visible
		$Controls/ControllerStuff/AltControls.visible = !$Controls/ControllerStuff/AltControls.visible
		
		Globals.control_prefix = "" if Globals.control_prefix == "_alt" else "_alt"


func _on_Quit_pressed():
	get_tree().quit()
