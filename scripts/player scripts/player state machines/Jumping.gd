extends State

@onready var fullhop_timer =  $"../../fullhop_timer"
#Can hold the jump button for up to 12 frames to vary jump height
	#works as follows: set upwards velocity to jump and set gravity to zero, 
	#set gravity to normal amount when a is released,  or after 10 frames has passed
var FULLHOP_TIME_LENGTH = .35

@onready var jump_buffer_timer = $"../../jump_buffer_timer"

var JUMP_BUFFER_LENGTH = .08

@export
var walk_state: State
@export
var idle_state: State
@export
var jump_peak_state: State
@export
var fall_state: State




#slight boost to speed when jumping
const SPEED = 300
const ACCELERATION = .9
const VEL_POW = 1.3

const JUMP_VELOCITY = -230

const JUMP_HANG_THRESHOLD = 60




var current_gravity = 0
var target_speed = 0

var jump_buffered = false

func enter():
	fall_state.can_jump = false
	current_gravity = 0
	parent.velocity.y = JUMP_VELOCITY
	fullhop_timer.start(FULLHOP_TIME_LENGTH)
	
	var direction = Input.get_axis("ui_left", "ui_right")
	target_speed = direction*SPEED
	
	parent.sprite.play(animation_name)
	return
	
func exit():
	fullhop_timer.stop()
	jump_buffer_timer.stop()
	return
	
func input_step(event: InputEvent) -> State:
	var direction = Input.get_axis("ui_left", "ui_right")
	target_speed = direction*SPEED
	if Input.is_action_just_released("ui_accept"):
		current_gravity = parent.DEFAULT_GRAVITY
		fullhop_timer.stop()
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer.start(JUMP_BUFFER_LENGTH)
		jump_buffered = true
	return null
	
func logic_step(delta) -> State:
	return null
	
func physics_step(delta) -> State:
	var vel_diff = target_speed - parent.velocity.x
	var temp_accel = pow(ACCELERATION * abs(vel_diff), VEL_POW)*sign(vel_diff)
	
	parent.velocity.x += temp_accel * delta
	
	parent.velocity.y += current_gravity * delta
	parent.move_and_slide()
	
	#if player hits a flat ceiling, immediately enter falling state
	for i in parent.get_slide_collision_count():
		if parent.get_slide_collision(i).get_normal() == Vector2(0, 1):
			parent.velocity.y = 0
			return fall_state
	
	
	#otherwise check if our jump has interrupted and we landed 
		#(edit: i dont think this is actually possible since we must be traveling upwards, but its here just in case)
	if parent.is_on_floor():
		if jump_buffered:
			return self
		if parent.velocity.x == 0:
			return idle_state
		else:
			return walk_state
	#finally if we dont "bonk" into the ceiling, enter the jump peak state (increases gravity/acceleration/velocity)
	if abs(parent.velocity.y) < JUMP_HANG_THRESHOLD:
		return jump_peak_state
	return null
	
	



func _on_fullhop_timer_timeout():
	current_gravity = parent.DEFAULT_GRAVITY


func _on_jump_buffer_timer_timeout():
	jump_buffered = false
