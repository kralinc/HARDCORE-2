extends RigidBody2D


export var WALK_VELOCITY = 5000
var facing_left = false

onready var sprite = $AnimatedSprite
onready var ledge_ray = $LedgeRay
onready var wall_ray = $WallRay

export var ledge_ray_direction:Vector2
export var wall_ray_direction:Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play()

func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()
	var direction = -1 if facing_left else 1
	
	var ledge_space_state = ledge_ray.get_world_2d().direct_space_state
	var ledge_result = ledge_space_state.intersect_ray(position, Vector2(position.x + ledge_ray_direction.x * direction, position.y + ledge_ray_direction.y))
	var wall_space_state = wall_ray.get_world_2d().direct_space_state
	var wall_result = wall_space_state.intersect_ray(Vector2(position.x, position.y), Vector2(position.x + wall_ray_direction.x * direction, position.y + wall_ray_direction.y * direction))
	
	if (!ledge_result or wall_result):
		facing_left = !facing_left
		sprite.scale.x *= -1
		
	lv.x = WALK_VELOCITY * direction * step
	
	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)
