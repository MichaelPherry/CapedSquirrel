extends State

#name for debugging
var state_name = "jump_peak"
#"pointer" to timer
@onready var jump_buffer_timer = $"../../jump_buffer_timer"



#multipliers to increase velocity/acceleration respectively
const ACCEL_MOD = 1.5
const VEL_MOD = 1.3
#speed (base speed times velocity modifier )
const SPEED = PlayerData.BASE_SPEED*VEL_MOD


#lowered gravity at apex of jump
const GRAVITY_MODIFIER = .75
var GRAVITY = PlayerData.DEFAULT_GRAVITY*GRAVITY_MODIFIER

var target_speed = 0


func enter():
	#calculate movement
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	#set animation
	parent.sprite.play(animation_name)
	return
	
	
func exit():
	pass
	
func input_step(event: InputEvent) -> State:
	#get input, buffer jump if pressed and calculate movement direction
	if Input.is_action_just_pressed(PlayerData.controls["jump"]):
		jump_buffer_timer.start(PlayerData.JUMP_BUFFER_LENGTH)
		PlayerData.jump_buffered = true
	if Input.is_action_just_pressed(PlayerData.controls["glide"]):
		return parent.glide_state
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	
	return null
	
	
func physics_step(delta) -> State:
	#calculate acceleration and gravity, update velocity and move
	var temp_accel = PlayerData.calcTempAccel(target_speed, parent.velocity.x, SPEED, ACCEL_MOD, PlayerData.AIR_DRAG)
	
	parent.velocity.x += (temp_accel * delta)
	parent.velocity.y += (GRAVITY*delta)
	#want to maybe implement a grace window where u get a boost in your jump if ur just about to clear an obstacle
	parent.move_and_slide()
	
	if Global.is_hooked:
		return parent.hooked_state
	
	var collision_state = parent.handle_air_collision()
	if collision_state:
		return collision_state
		
	#finally, enter the fall state if we are traveling fast enough
	if parent.velocity.y > PlayerData.HANG_THRESHOLD:
		return parent.fall_state
		
	return null
	



