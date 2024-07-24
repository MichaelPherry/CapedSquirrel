extends State

@onready
var exit_timer = $"../../walljump_timer"

@onready
var accel_timer = $"../../ignore_accel_timer"

const state_name = "walljump"

const SPEED =PlayerData.BASE_SPEED*.5

const WALLJUMP_BOOST = 6
const WALLJUMP_HEIGHT = .8

const ACCEL_MOD = PlayerData.AERIAL_ACCEL_MOD*2
const VEL_MOD = 1.5

const TIME_IN_WALLJUMP = .12
const TIME_IN_NOACCEL = .08

var GRAVITY = PlayerData.DEFAULT_GRAVITY

var target_speed = 0
var current_gravity = 0

var wall_norm = 0

func enter():
	current_gravity = 0
	
	accel_timer.stop
	exit_timer.start(TIME_IN_WALLJUMP)
	parent.sprite.play(animation_name)
	target_speed = (((PlayerData.BASE_SPEED*VEL_MOD)+ (PlayerData.JUMP_BOOST*WALLJUMP_BOOST))*wall_norm)
	parent.velocity.y = PlayerData.JUMP_VELOCITY*WALLJUMP_HEIGHT
	wall_norm = 0
	#get input, buffer jump if pressed and calculate movement direction
	if !(Input.is_action_pressed(PlayerData.controls["jump"])):
		parent.state_machine.change_state(parent.jump_peak_state)
	
		
	
	return
	
func exit():
	PlayerData.ignore_accel = true
	
	exit_timer.stop()
	
	accel_timer.start(TIME_IN_NOACCEL)
	pass
	
	
func input_step(event: InputEvent) -> State:
	#get input, buffer jump if pressed and calculate movement direction
	if !(Input.is_action_pressed(PlayerData.controls["jump"])):
		current_gravity = GRAVITY
	if Input.is_action_just_pressed(PlayerData.controls["glide"]):
		return parent.glide_state
	return null
	
func logic_step(delta) -> State:
	return null
	
func physics_step(delta) -> State:
	#calc accel and gravity and update velocities and move character
	var temp_accel = PlayerData.calcTempAccel(target_speed, parent.velocity.x, SPEED, ACCEL_MOD, PlayerData.AIR_DRAG)
	
	parent.velocity.x += (temp_accel * delta)
	parent.velocity.y += current_gravity * delta
	parent.move_and_slide()
		
	if Global.is_hooked:
		return parent.hooked_state
		
	return parent.handle_air_collision()
	
		



func _on_walljump_timer_timeout():
	parent.state_machine.change_state(parent.jump_peak_state)
