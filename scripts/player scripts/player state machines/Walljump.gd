extends State


const state_name = "walljump"

const SPEED =PlayerData.BASE_SPEED*.5

const WALLJUMP_BOOST = 2.5
const WALLJUMP_HEIGHT = .65
const WALLJUMP_ACCEL = .25

const WALLJUMP_GRAV_MOD = .48

var GRAVITY = PlayerData.DEFAULT_GRAVITY*WALLJUMP_GRAV_MOD

var target_speed = 0
var current_gravity = 0

func enter():
	parent.sprite.play(animation_name)
	
	
	#get input, buffer jump if pressed and calculate movement direction
	if !(Input.is_action_pressed(PlayerData.controls["jump"])):
		current_gravity = GRAVITY
	if Input.is_action_just_pressed(PlayerData.controls["jump"]):
		parent.jump_state.jump_modifier = WALLJUMP_HEIGHT
		parent.jump_state.jump_boost_modifier = WALLJUMP_BOOST
		PlayerData.accel_modifier = WALLJUMP_ACCEL
		return parent.jump_state
	var dir = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = dir*SPEED
		
	
	return
	
func exit():
	pass
	
	
func input_step(event: InputEvent) -> State:
	#get input, buffer jump if pressed and calculate movement direction
	if !(Input.is_action_pressed(PlayerData.controls["jump"])):
		current_gravity = GRAVITY
	if Input.is_action_just_pressed(PlayerData.controls["jump"]):
		parent.jump_state.jump_modifier = WALLJUMP_HEIGHT
		parent.jump_state.jump_boost_modifier = WALLJUMP_BOOST
		PlayerData.accel_modifier = WALLJUMP_ACCEL
		return parent.jump_state
	var dir = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = dir*SPEED
	return null
	
func logic_step(delta) -> State:
	return null
	
func physics_step(delta) -> State:
	parent.velocity.x += (target_speed)*0.25*delta
	parent.velocity.y += (current_gravity*delta)
	
	parent.move_and_slide()
	
	if !(parent.is_on_wall()):
		parent.jump_state.jump_modifier = 1
		parent.jump_state.jump_boost_modifier = 1
		PlayerData.accel_modifier = 1
		parent.jump_state.wall_jump = 0
		if parent.velocity.y > (PlayerData.HANG_THRESHOLD):
			return parent.fall_state
		return parent.jump_peak_state
	if parent.is_on_floor():
		parent.jump_state.wall_jump = 0
		PlayerData.accel_modifier = 1
		parent.jump_state.jump_modifier = 1
		parent.jump_state.jump_boost_modifier = 1
		return parent.idle_state
	return null
		






