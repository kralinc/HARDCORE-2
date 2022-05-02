extends KinematicBody2D


var BASE_POS
var FALL_VELOCITY = 200
var shaking = false
var falling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	BASE_POS = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(Vector2(0, FALL_VELOCITY if falling else 0) * delta)

func _on_Timer_timeout():
	$Timer.stop()
	$RespawnTimer.start()
	falling = true


func _on_RespawnTimer_timeout():
	$RespawnTimer.stop()
	position = BASE_POS
	falling = false
	shaking = false


func _on_Area2D_body_entered(body):
	if not shaking and not falling:
		$Timer.start()
		$AnimationPlayer.play("shake")
		shaking = true
