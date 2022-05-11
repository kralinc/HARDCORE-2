extends AnimatedSprite


export var speed = 300


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed * delta


func _on_SafeArea_body_entered(body):
	print("pink now safe")
	$Area2D.set_collision_layer_bit(1, false)
	$Area2D.set_collision_mask_bit(1, false)
