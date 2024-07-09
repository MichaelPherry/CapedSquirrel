extends State

@onready var coyote_timer = $"../../coyote_timer"
#allows for 5 frames leniency to input jump after entering fall (not letting me make it a constant for whatever reason)
var COYOTE_TIME_LENGTH = .15

@onready var jump_buffer_timer = $"../../jump_buffer_timer"

var JUMP_BUFFER_LENGTH = .1

@export
var jump_state: State
@export
var walk_state: State
@export
var idle_state: State



const SPEED = 120
const ACCELERATION = .65
const DECCELERATION = .85
const VEL_POW = 1.5

const MAX_FALL_SPEED = 600


var can_jump = false
var target_speed = 0

var jump_buffered = false

func enter():
	coyote_timer.start(COYOTE_TIME_LENGTH)
	
	var direction = Input.get_axis("ui_left", "ui_right")
	target_speed = direction*SPEED
	
	parent.sprite.play(animation_name)
	return
	
	
func exit():
	coyote_timer.stop()
	jump_buffer_timer.stop()
	return
	
func input_step(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_accept"):
		if can_jump:
			return jump_state
		else:
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
	parent.velocity.y += parent.DEFAULT_GRAVITY*delta
	
	if parent.velocity.y > MAX_FALL_SPEED:
		parent.velocity.y = MAX_FALL_SPEED
	parent.move_and_slide()
	
	if parent.is_on_floor:
		if jump_buffered:
			return jump_state
		if parent.velocity.x == 0:
			return idle_state
		else:
			return walk_state
	
	return null



func _on_coyote_timer_timeout():
	can_jump = false
	



func _on_jump_buffer_timer_timeout():
	jump_buffered = false
