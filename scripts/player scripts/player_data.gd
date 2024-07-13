extends Node

#store globals specific to player here, also accessible from every scene/script


#base (grounded) speed and acceleration
const BASE_SPEED = 128
const BASE_ACCELERATION = BASE_SPEED/8 #8 and 5 signify the number of frames desired to reach top speed or fully stop
const BASE_DECCELERATION = BASE_SPEED/5
#modifier for acceleration in the air
const AERIAL_ACCEL_MOD = .6
#(good for checking if desired speed is zero when a controller has drift)
const STOP_VEL = .1
#jump height and horizontal boost to velocity when jumping
const JUMP_VELOCITY = -118
const JUMP_BOOST = 50
#value determining the "peak" of jump
const HANG_THRESHOLD = 48


#drag values to dampen acceleration when traveling above top speed
#this allows the player to better preserve momentum when they find themselves moving very fast for whatever reason (this being too low caused the infinite bunny hop)

#const GROUND_DRAG = 150, manually placed in the calcdrag function because you can not set a default parameter to a variable :(, my beautiful intuitive code is ruined
const AIR_DRAG = 130

var DEFAULT_GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
#timer lengths to determine max jump height, how long to buffer jump when pressed in the air, and the grace period to input jump after falling off a ledge (coyote time)
const COYOTE_TIME_LENGTH = .1
const JUMP_BUFFER_LENGTH = .13
const FULLHOP_LENGTH = .2



#booleans dealing with player
var jump_buffered = false
var conserve_momentum = true
#dictionary respresenting control scheme
var controls = {"left": "ui_left", "right": "ui_right", "jump": "ui_accept", "glide": "shift_key", "crouch": "ui_down"}

func calcTempAccel(target_speed, current_speed, top_speed, accel_mod = 1, drag = 150):
	#magic function to calculate acceleration based on magic stuff
	var base_accel = BASE_ACCELERATION
	var speed_diff = target_speed-current_speed
	
	if (abs(target_speed) < STOP_VEL):
		base_accel = BASE_DECCELERATION
	elif (abs(current_speed) > top_speed) and (sign(current_speed) == sign(target_speed)):
		return drag*(sign(speed_diff))
		
	
	base_accel *= accel_mod
	
	
	
	return (base_accel*(speed_diff))
	
	
	
