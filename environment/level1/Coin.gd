extends AnimatedSprite

func _ready():
	self.play()


func _on_Area2D_body_entered(body):
	if visible:
		$CoinSound.play()
		visible = false


func _on_CoinSound_finished():
	queue_free()
