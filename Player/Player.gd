extends RigidBody2D

signal hit

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var hitbox = $Hitbox
onready var die_sound = $DieSound
onready var jump_sound = $JumpSound

var MAX_WALK_VEL = 300
var WALK_ACCEL = 2400
var WALK_DECEL = 2400
var RUN_ACCEL_MOD = 1.25
export var JUMP_POWER = 400
export var STOP_JUMP_GRAV = 1400

var air_time = 1e20
var floor_velocity:Vector2
var floor_position = Vector2(0, 0)
var jumping = false
var facing_left = false
var dead = false
var anim = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _integrate_forces(state):
	var linear_vel = state.get_linear_velocity()
	var step = state.get_step()

	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var run = Input.is_action_pressed("run")
	var jump = Input.is_action_pressed("jump")
	var restart = Input.is_action_just_pressed("restart")
	
	if dead and restart:
		# TODO CHANGE THIS TO LEVEL 1
		get_tree().change_scene("res://DEV.tscn")

	var grounded = false
	var floor_index = -1
	
	for x in range(state.get_contact_count()):
		var contact = state.get_contact_local_normal(x)
		
		if contact.dot(Vector2(0, -1)) > 0.6:
			grounded = true
			floor_index = x
			
	linear_vel -= floor_velocity
	floor_velocity = Vector2(0, 0)
	
	if jumping:
		if linear_vel.y > 0:
			jumping = false
		elif not jump:
			linear_vel.y += STOP_JUMP_GRAV * step
		
	var runMod = 1
	if run:
		runMod = RUN_ACCEL_MOD
			
	if not dead:
		if left and not right and linear_vel.x > -MAX_WALK_VEL * runMod:
			linear_vel.x -= WALK_ACCEL * step * runMod
		elif right and not left and linear_vel.x < MAX_WALK_VEL * runMod:
			linear_vel.x += WALK_ACCEL * step * runMod
		else:
			var xv = abs(linear_vel.x)
			xv -= WALK_DECEL * step
			if xv < 0:
				xv = 0
			linear_vel.x = sign(linear_vel.x) * xv
			
		if grounded:
			if not jumping and jump:
				jumping = true
				linear_vel.y = -JUMP_POWER - (abs(linear_vel.x) / 2)
				jump_sound.play(0)
				
	if dead:
		linear_vel.x = 0
		
	if grounded:
		air_time = 0.0
		floor_velocity = Vector2(state.get_contact_collider_velocity_at_position(floor_index).x, 0)
		linear_vel += floor_velocity
	else:
		air_time += step
		
	linear_vel += state.get_total_gravity() * step
	state.set_linear_velocity(linear_vel)
	setAnimation(grounded, left, right, run)



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

func _on_Hitbox_body_entered(body):
	die()


func _on_Hitbox_area_entered(area):
	die()
