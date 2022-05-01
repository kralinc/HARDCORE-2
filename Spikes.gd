extends Node2D


export var TO_VELOCITY = 400
export var FROM_VELOCITY = 200
export var TRAVEL_DISTANCE = Vector2(0,-400)
var BASE_POS

var moving_to = true

# Called when the node enters the scene tree for the first time.
func _ready():
	BASE_POS = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.distance_to(BASE_POS) >= TRAVEL_DISTANCE.length():
		moving_to = false
	elif not moving_to and position.distance_to(BASE_POS) <= 1.0:
		moving_to = true
		position = BASE_POS
	
	if moving_to:
		position = position.move_toward(position + TRAVEL_DISTANCE, delta * TO_VELOCITY)
	else:
		position = position.move_toward(BASE_POS, delta * FROM_VELOCITY)
