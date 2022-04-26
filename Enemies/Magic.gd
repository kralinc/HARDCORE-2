class_name Magic
extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = Vector2(0,0)
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += direction.x * delta
	position.y += direction.y * delta

func setDirection(dir:Vector2):
	direction = dir.normalized() * speed

func _on_Timer_timeout():
	queue_free()
