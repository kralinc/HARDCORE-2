extends Sprite


export var UP_VELOCITY = 1000
export var DOWN_VELOCITY = 200
export var TRAVEL_DISTANCE = 1000 setget set_travel_distance
var BASE_Y = -1

var moving_up = false

func set_travel_distance(val):
	TRAVEL_DISTANCE = val

# Called when the node enters the scene tree for the first time.
func _ready():
	BASE_Y = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if BASE_Y - position.y >= TRAVEL_DISTANCE:
		moving_up = false
	elif not moving_up and position.y >= BASE_Y:
		moving_up = true
		position.y = BASE_Y
	
	if moving_up:
		position.y -= UP_VELOCITY * delta
	else:
		position.y += DOWN_VELOCITY * delta
