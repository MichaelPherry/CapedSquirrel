extends CharacterBody2D


const SPEED = 650
const JUMP_VELOCITY = -480

const VEL_POW = 1.3

const JUMP_HANG_THRESHOLD = 60
const JUMP_HANG_MODIFIER = .88

const DEFAULT_ACCEL = .75
const HANG_ACCEL = .88

const COYOTE_TIME_MAX = 5

const FULLHOP_TIME_MAX = 30



# Get the gravity from the project settings to be synced with RigidBody nodes.

var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")*.8

var curr_gravity = default_gravity
#set number of jumps, allows for double jump implementation sooner
var total_jumps = 1

var curr_jumps = total_jumps

var curr_accel = DEFAULT_ACCEL



@onready var coyote_timer = $coyote_timer

@onready var fullhop_timer = $fullhop_timer




func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		if abs(velocity.y) < JUMP_HANG_THRESHOLD:
			curr_gravity = default_gravity*JUMP_HANG_MODIFIER	
			curr_accel = HANG_ACCEL
		elif curr_gravity != 0:
			curr_gravity = default_gravity
			curr_accel = DEFAULT_ACCEL
		velocity.y += (curr_gravity * delta * curr_accel)
		if coyote_timer.is_stopped():
#passing through number of frames of coyote_time (COYOTE_TIME_MAX or 5 frames) and normalizes to seconds
			coyote_timer.start(COYOTE_TIME_MAX/Engine.get_frames_per_second())
		
	else:
		curr_gravity = default_gravity
		curr_accel = DEFAULT_ACCEL
		curr_jumps = total_jumps
		
		coyote_timer.stop()
		fullhop_timer.stop()
		
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and curr_jumps:
		velocity.y = JUMP_VELOCITY
		curr_gravity = 0
		curr_jumps -= 1
		fullhop_timer.start(FULLHOP_TIME_MAX/Engine.get_frames_per_second())
		coyote_timer.stop()
		
	if Input.is_action_just_released("ui_accept") and curr_gravity == 0:
		curr_gravity = default_gravity 
		fullhop_timer.stop()
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	#lots of mumbo jumbo here, basically determines which direction we want to move in (left, right or stop)
	#it then determines the acceleration based on how far away our current speed is from our target speed
	var direction = Input.get_axis("ui_left", "ui_right")
	var target_speed = direction*SPEED
	
	var vel_diff = target_speed - velocity.x
	var temp_accel = pow(curr_accel * abs(vel_diff), VEL_POW)*sign(vel_diff)
	
	velocity.x += temp_accel * delta

	move_and_slide()
	
	



func _on_coyote_timer_timeout():
	if curr_jumps == total_jumps:
		curr_jumps -= 1


func _on_fullhop_timer_timeout():
	if curr_gravity == 0:
		curr_gravity = default_gravity
