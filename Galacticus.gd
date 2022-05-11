extends Node

signal pause_changed

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		emit_signal("pause_changed")
		get_tree().paused = !get_tree().paused
