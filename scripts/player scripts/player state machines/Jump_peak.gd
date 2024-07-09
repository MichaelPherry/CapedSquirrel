extends State

@onready var jump_buffer_timer = $"../../jump_buffer_timer"

var JUMP_BUFFER_LENGTH = .1

@export
var walk_state: State
@export
var idle_state: State
@export
var fall_state: State
@export
var jump_state: State



const JUMP_HANG_THRESHOLD = 60

const SPEED = 360
const ACCELERATION = .98
const VEL_POW = 1.3

const GRAVITY_MODIFIER = .84

var target_speed = 0

var jump_buffered = false

func enter():
	var direction = Input.get_axis("ui_left", "ui_right")
	target_speed = direction*SPEED
	
	parent.sprite.play(animation_name)
	return
	
	
func exit():
	jump_buffer_timer.stop()
	return
	
func input_step(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer.start(JUMP_BUFFER_LENGTH)
		jump_buffered = true
	
	var direction = Input.get_axis("ui_left", "ui_right")
	target_speed = direction*SPEED
	
	return null
	
func logic_step(delta) -> State:
	return super(delta)
	
func physics_step(delta) -> State:
	var vel_diff = target_speed - parent.velocity.x
	var temp_accel = pow(ACCELERATION * abs(vel_diff), VEL_POW)*sign(vel_diff)
	
	parent.velocity.x += temp_accel * delta
	parent.velocity.y += (parent.DEFAULT_GRAVITY*delta*GRAVITY_MODIFIER)
	#want to maybe implement a grace window where u get a boost in your jump if ur just about to clear an obstacle
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
			return jump_state
		if parent.velocity.x == 0:
			return idle_state
		else:
			return walk_state
	#finally if we dont "bonk" into the ceiling, enter the jump peak state (increases gravity/acceleration/velocity)
	if parent.velocity.y > JUMP_HANG_THRESHOLD:
		return fall_state
	return null
	



func _on_jump_buffer_timer_timeout():
	jump_buffered = false
