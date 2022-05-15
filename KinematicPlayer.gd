extends KinematicBody2D


signal hit

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var hitbox = $Hitbox
onready var die_sound = $DieSound
onready var jump_sound = $JumpSound

onready var alt = Globals.control_prefix

var WALK_VEL = 300
var RUN_ACCEL_MOD = 1.33
var FLOOR_DETECT_DISTANCE = 20.0
var MAX_TIME_FOR_AIRBORNE_JUMP = 0.125 #grace period if you're just barely off a platform
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
var air_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	
	if dead and Input.is_action_just_pressed("walk" + alt):
		get_tree().reload_current_scene()
		
	if not is_on_floor():
		air_time += delta
	else:
		air_time = 0.0

	var direction = get_direction(_velocity)
	
	var walk_mod = 1 if Input.is_action_pressed("walk" + alt) else RUN_ACCEL_MOD

	var is_jump_interrupted = Input.is_action_just_released("jump" + alt) and _velocity.y < 0.0
	var move_velocity_x = WALK_VEL * walk_mod
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
		Input.is_action_pressed("move_left" + alt), 
		Input.is_action_pressed("move_right" + alt), 
		Input.is_action_pressed("walk" + alt))

func get_direction(velocity):
	return Vector2(
		1 if Input.is_action_pressed("move_right" + alt) else 0 - 1 if Input.is_action_pressed("move_left" + alt) else 0,
		-1 if is_on_floor() and Input.is_action_just_pressed("jump" + alt) or can_jump_midair(velocity) else 0
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
		jump_sound.play()
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity

func setAnimation(grounded, left, right, walk):
	var new_anim = anim
	var newly_facing_left = facing_left
	
	if left:
		newly_facing_left = true
	elif right:
		newly_facing_left = false
	
	if not dead:
		if grounded:
			animation_player.playback_speed = 1.5 if walk else 2
			
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
		
func can_jump_midair(velocity):
	return Input.is_action_just_pressed("jump" + alt) and velocity.y > 0.0 and air_time < MAX_TIME_FOR_AIRBORNE_JUMP

func die():
	if not Globals.hardcore:
		if not dead:
			die_sound.play()
			dead = true
			emit_signal("hit")
			_velocity.x = 0
			Globals.deaths += 1
	else:
		gameover()
		
func gameover():
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	var ff = ImageTexture.new()
	ff.create_from_image(image)
	Globals.fatal_frame = ff
	get_tree().change_scene("res://Gameover.tscn")

func _on_Hitbox_body_entered(body):
	die()


func _on_Hitbox_area_entered(area):
	die()


func _on_Teleporter_teleporting():
	$Hitbox.set_collision_layer_bit(1, false)
	$Hitbox.set_collision_mask_bit(1, false)
	_velocity.x = 0
	dead = true


func _on_Galacticus_pause_changed():
	$HUD/PauseScreen.visible = !$HUD/PauseScreen.visible
	$HUD/PauseScreen/QuitButton.grab_focus()


func _on_QuitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://mainmenu.tscn")
