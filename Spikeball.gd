extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time_passed = 0
var base_pos
export var amplitude = 100
export var x_speed = 2.0
export var y_speed = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	base_pos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	
	position = Vector2(base_pos.x + amplitude + (amplitude * sin(time_passed * x_speed)),
		base_pos.y + amplitude + (amplitude * cos(time_passed * y_speed)))
