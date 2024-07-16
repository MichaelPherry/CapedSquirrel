extends State

#name for debugging
var state_name = "gliding"
#"pointer" to timer
@onready var jump_buffer_timer = $"../../jump_buffer_timer"

const GLIDE_BOOST = -48
const GLIDE_GRAV_MOD = .32

var GRAVITY = PlayerData.DEFAULT_GRAVITY*GLIDE_GRAV_MOD

const SPEED_MOD = 1.3
const ACCEL_MOD = .75

var SPEED = PlayerData.BASE_SPEED*SPEED_MOD

var target_speed = 0

func enter():
	parent.sprite.play(animation_name)
	#boost in velocity if not holding down
	if !(Input.is_action_pressed(PlayerData.controls["crouch"])):
		parent.velocity.y = GLIDE_BOOST
	else:
		parent.velocity.y = 0
	#calculate movement
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	#set animation
	parent.sprite.play(animation_name)
	return
		
	return
	
func exit():
	pass
	
func input_step(event: InputEvent) -> State:
	#get input, buffer jump if pressed and calculate movement direction
	if Input.is_action_just_pressed(PlayerData.controls["jump"]):
		jump_buffer_timer.start(PlayerData.JUMP_BUFFER_LENGTH)
		PlayerData.jump_buffered = true
		
	if Input.is_action_just_pressed(PlayerData.controls["glide"]):
		return parent.fall_state
	
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	
	return null
	
func logic_step(delta) -> State:
	return null
	
func physics_step(delta) -> State:
	#calculate acceleration and gravity, update velocity and move
	var temp_accel = PlayerData.calcTempAccel(target_speed, parent.velocity.x, SPEED, ACCEL_MOD, PlayerData.AIR_DRAG)
	
	parent.velocity.x += (temp_accel * delta)
	parent.velocity.y += (GRAVITY*delta)
	#want to maybe implement a grace window where u get a boost in your jump if ur just about to clear an obstacle
	parent.move_and_slide()
	
	return parent.handle_air_collision()

