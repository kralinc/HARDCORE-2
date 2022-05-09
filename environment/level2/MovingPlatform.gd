extends Node2D

onready var anim = get_node("AnimationPlayer")
onready var platform_body = get_node("PlatformBody")

export var destination = Vector2()
export var time_to_destination = 4

func _ready():
	# Set up a unique animation for this platform according to its destination vars
	var move_anim = Animation.new()
	move_anim.length = time_to_destination * 2
	move_anim.loop = true
	move_anim.add_track(Animation.TYPE_VALUE)
	move_anim.track_set_path(0, str(platform_body.get_path()) + ":position")
	move_anim.track_insert_key(0, 0, Vector2(0,0))
	move_anim.track_insert_key(0, time_to_destination, destination)
	anim.add_animation(str(get_instance_id()), move_anim)

	anim.play(str(get_instance_id()))
