extends KinematicBody2D


signal hit

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var hitbox = $Hitbox
onready var die_sound = $DieSound
onready var jump_sound = $JumpSound
onready var platform_collider = $PlatformCollider

var WALK_VEL = 300
var RUN_ACCEL_MOD = 1.33
var FLOOR_DETECT_DISTANCE = 20.0
export var JUMP_POWER = 600
export var STOP_JUMP_GRAV = 1400
export var GRAVITY = Vector2(0, 9800)
export var MOVE_JUMP_MOD = 0.4

var _velocity = Vector2(0, 0)
var floor_velocity:Vector2
var floor_position = Vector2(0, 0)
var jumping = false
var facing_left = false
var dead = false
var anim = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var restart = Input.is_action_just_pressed("restart")
	
	if dead and restart:
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and not dead:
		jump_sound.play()

	var direction = get_direction()
	
	var run_mod = RUN_ACCEL_MOD if Input.is_action_pressed("run") else 1

	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var move_velocity_x = WALK_VEL * run_mod
	var move_velocity_y = JUMP_POWER + abs((_velocity.x * MOVE_JUMP_MOD))
	if not dead:
		_velocity = calculate_move_velocity(_velocity, direction, Vector2(move_velocity_x, move_velocity_y), is_jump_interrupted)
	_velocity += GRAVITY * delta
	
	var snap_vector = Vector2.ZERO
	if direction.y == 0.0:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, Vector2.UP, true, 4, 0.9, false
	)
	
	setAnimation(
		is_on_floor(), 
		Input.is_action_pressed("move_left"), 
		Input.is_action_pressed("move_right"), 
		Input.is_action_pressed("run"))

func get_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1 if is_on_floor() and Input.is_action_just_pressed("jump") else 0
	)

func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity

func setAnimation(grounded, left, right, run):
	var new_anim = anim
	var newly_facing_left = facing_left
	
	if left:
		newly_facing_left = true
	elif right:
		newly_facing_left = false
	
	if not dead:
		if grounded:
			animation_player.playback_speed = 1.5 if run else 1
			
			if left or right:
				new_anim = "run"
			else:
				new_anim = "idle"
		else:
			new_anim = "jump"
	else:
		new_anim = "die"
		
	if newly_facing_left != facing_left:
		if newly_facing_left:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1
			
		facing_left = newly_facing_left
		
	if new_anim != anim:
		anim = new_anim
		animation_player.play(anim)

func die():
	if not dead:
		die_sound.play()
		dead = true
		emit_signal("hit")
		_velocity.x = 0
		Globals.lives -= 1

func _on_Hitbox_body_entered(body):
	die()


func _on_Hitbox_area_entered(area):
	die()
