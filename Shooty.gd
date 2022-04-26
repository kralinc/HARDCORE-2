extends AnimatedSprite

var Magic = preload("res://Enemies/Magic.tscn")

onready var player = get_tree().root.get_child(0).find_node("Player")

enum STATE {
	IDLE
	READY
	SHOOTING
}

export var SEE_DISTANCE = 500

var state = STATE.READY
var facingLeft = false

# Called when the node enters the scene tree for the first time.
func _ready():
	play()



func _process(delta):
	var playerDirection = player.position.x - position.x
	var newFacingLeft = false
	if playerDirection < 0:
		newFacingLeft = true
		
	if newFacingLeft != facingLeft:
		facingLeft = newFacingLeft
		scale.x *= -1
		
	set_state()

func _on_ShootTimer_timeout():
	if state == STATE.READY:
		state = STATE.SHOOTING
		play("attack")
		var m = Magic.instance()
		get_parent().add_child(m)
		
		m.position = position
		var direction = player.position - position
		m.setDirection(direction)


func _on_Shooty_animation_finished():
	match state:
		STATE.SHOOTING:
			play("default")
			state = STATE.READY

func set_state():
	var distance_to_player = position.distance_to(player.position)
	
	var new_state = state
	
	if state != STATE.SHOOTING:
		if distance_to_player <= SEE_DISTANCE:
			new_state = STATE.READY
		else:
			new_state = STATE.IDLE
	
	if state != new_state:
		state = new_state
