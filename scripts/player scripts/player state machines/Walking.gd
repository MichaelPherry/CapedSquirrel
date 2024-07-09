extends State


@export
var jump_state: State
@export
var fall_state: State
@export
var idle_state: State



const SPEED = 270
const ACCELERATION = .9
const VEL_POW = 1.3

var target_speed = 0


func _ready():
	return

func enter():
	fall_state.can_jump = true
	
	var direction = Input.get_axis("ui_left", "ui_right")
	target_speed = direction*SPEED
	
	parent.sprite.play(animation_name)
	return
	
func exit():
	pass
	
func input_step(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_accept"):
		return jump_state
	var direction = Input.get_axis("ui_left", "ui_right")
	target_speed = direction*SPEED
	if direction != 0:
		#parent.animator.x_scale?? = direction
		#set animation to direction you are trying to move
		return null
	return null
	
func logic_step(delta) -> State:
	return super(delta)
	
func physics_step(delta) -> State:
	
	
	var vel_diff = target_speed - parent.velocity.x
	var temp_accel = pow(ACCELERATION * abs(vel_diff), VEL_POW)*sign(vel_diff)
	
	parent.velocity.x += temp_accel * delta
	parent.velocity.y += parent.DEFAULT_GRAVITY*delta

	parent.move_and_slide()
	if !parent.is_on_floor():
		return fall_state
	if parent.velocity.x == 0:
		return idle_state
		
	return null

