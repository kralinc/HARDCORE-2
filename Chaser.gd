extends RigidBody2D


onready var player = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1).find_node("Player")
onready var sprite = $AnimatedSprite

enum STATE {
	IDLE
	CHASE
}

export var CHASE_ACCELERATION = 400
export var MAX_VELOCITY = 1000
export var CHASE_DISTANCE = 400
export var DETECT_DISTANCE = 200

var state = STATE.IDLE
var elapsed = 0.0
var facing_left = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play()

func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()
	elapsed += step
	set_state()
	match state:
		STATE.IDLE:
			lv.x = (cos(elapsed) * (MAX_VELOCITY)) * step
		STATE.CHASE:
			var direction
			var direction_to_player = position - player.position
			direction = 1 if direction_to_player.x < 0 else -1
			if abs(lv.x) < MAX_VELOCITY:
				lv.x += CHASE_ACCELERATION * direction * step
			
	var new_facing_left = lv.x < 0
	if new_facing_left != facing_left:
		facing_left = new_facing_left
		sprite.scale.x *= -1
	
	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)
		

func set_state():
	var distance_to_player = position.distance_to(player.position)
	match state:
		STATE.IDLE:
			state = STATE.CHASE if distance_to_player <= DETECT_DISTANCE else STATE.IDLE
		STATE.CHASE:
			state = STATE.CHASE if distance_to_player <= CHASE_DISTANCE else STATE.IDLE
