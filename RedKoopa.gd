extends RigidBody2D


var WALK_VELOCITY = 5000
var facing_left = false

onready var sprite = $AnimatedSprite
onready var ledge_ray = $LedgeRay
onready var wall_ray = $WallRay


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play()

func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()
	var direction = -1 if facing_left else 1
	
	var ledge_space_state = ledge_ray.get_world_2d().direct_space_state
	var ledge_result = ledge_space_state.intersect_ray(position, Vector2(position.x + 20 * direction, position.y + 40))
	var wall_space_state = wall_ray.get_world_2d().direct_space_state
	var wall_result = wall_space_state.intersect_ray(Vector2(position.x, position.y + 25), Vector2(position.x + 20 * direction, position.y))
	if (!ledge_result or wall_result):
		facing_left = !facing_left
		sprite.scale.x *= -1
		
	lv.x = WALK_VELOCITY * direction * step
	
	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)
