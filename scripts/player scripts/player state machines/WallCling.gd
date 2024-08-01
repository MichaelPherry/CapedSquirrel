extends State


const state_name = "wallcling"

const SPEED =PlayerData.BASE_SPEED*.5

const WALLJUMP_BOOST = 2.5

const WALLJUMP_ACCEL = .25

const WALLJUMP_GRAV_MOD = 1.0

var GRAVITY = PlayerData.DEFAULT_GRAVITY*WALLJUMP_GRAV_MOD

var target_speed = 0
var current_gravity = GRAVITY


func enter():
	parent.sprite.play(animation_name)
	
	#get input, buffer jump if pressed and calculate movement direction
	if PlayerData.jump_buffered:
		return parent.walljump_state

	if Input.is_action_just_pressed(PlayerData.controls["jump"]):
		return parent.walljump_state
	var dir = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = dir*SPEED
		
	
	return
	
func exit():
	pass
	
	
func input_step(event: InputEvent) -> State:
	#get input, buffer jump if pressed and calculate movement direction
	
	if Input.is_action_just_pressed(PlayerData.controls["jump"]):
		return parent.walljump_state
	var dir = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = dir*SPEED
	return null
	
func logic_step(delta) -> State:
	return null
	
func physics_step(delta) -> State:
	#calc accel and gravity and update velocities and move character
	var temp_accel = PlayerData.calcTempAccel(target_speed, parent.velocity.x, SPEED, PlayerData.AERIAL_ACCEL_MOD, PlayerData.AIR_DRAG)
	
	parent.velocity.x += (temp_accel * delta)
	parent.velocity.y += current_gravity * delta
	parent.move_and_slide()
		
	if Global.is_hooked:
		return parent.hooked_state
		
	if parent.is_on_floor():
		return parent.idle_state
	
	if !(parent.is_on_wall()):
		parent.fall_state.can_jump = true
		parent.fall_state.wall_jump = true
		return parent.fall_state
	
	return null
		






