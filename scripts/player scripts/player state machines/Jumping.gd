extends State

#name for debugging
var state_name = "jumping"

#"pointers" to timers
@onready var fullhop_timer =  $"../../fullhop_timer"
@onready var jump_buffer_timer = $"../../jump_buffer_timer"

#speed is same as default 
const SPEED = PlayerData.BASE_SPEED


#when entering jump state, gravity starts at zero and returns when we release the jump key, or fullhop timer goes off
var current_gravity = 0
var target_speed = 0

var wall_jump = 0
var jump_modifier = 1
var jump_boost_modifier = 1


func enter():
	#ensure coyote time does not apply if we enter fall state from jump
	parent.fall_state.can_jump = false
	#gravity is zero at start of jump (comes back in after fullhop or on key release)
	current_gravity = 0
	parent.walljump_state.current_gravity = 0
	#set y velocity to jump height and add jump boost if we are moving in a direction
	parent.velocity.y = PlayerData.JUMP_VELOCITY*jump_modifier
	if wall_jump == 0:
		parent.velocity.x += sign(parent.velocity.x)*PlayerData.JUMP_BOOST*jump_boost_modifier
		
	else:
		parent.velocity.x = (SPEED*wall_jump)+(wall_jump*PlayerData.JUMP_BOOST*jump_boost_modifier)
	#set off fullhop timer to bring gravity back if player does not release jump
	fullhop_timer.start(PlayerData.FULLHOP_LENGTH)
	#calculate movement and set target speed
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	
	parent.sprite.play(animation_name)
	
	jump_modifier = 1
	jump_boost_modifier = 1
	wall_jump = 0
	return
	
func exit():
	PlayerData.accel_modifier = 1
	return
	
func input_step(event: InputEvent) -> State:
	#calculate movement and set target speed
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	# bring back gravity of jump key released 
	if Input.is_action_just_released(PlayerData.controls["jump"]):
		current_gravity = PlayerData.DEFAULT_GRAVITY
		fullhop_timer.stop()
	if Input.is_action_just_pressed(PlayerData.controls["glide"]):
		return parent.glide_state
	#if we input a jump, buffer in case we land
	if Input.is_action_just_pressed(PlayerData.controls["jump"]):
		jump_buffer_timer.start(PlayerData.JUMP_BUFFER_LENGTH)
		PlayerData.jump_buffered = true
	return null
	

	
func physics_step(delta) -> State:
	
	#calc accel and gravity and update velocities and move character
	var temp_accel = PlayerData.calcTempAccel(target_speed, parent.velocity.x, SPEED, PlayerData.AERIAL_ACCEL_MOD, PlayerData.AIR_DRAG)
	
	parent.velocity.x += (temp_accel * delta*PlayerData.accel_modifier)
	parent.velocity.y += current_gravity * delta
	parent.move_and_slide()
	
	if Global.is_hooked:
		return parent.hooked_state
	
	#if player hits a wall, enter wall jump
	
	var collision_state = parent.handle_air_collision()
	if collision_state:
		return collision_state
		
	#finally, enter the jump peak state (increases acceleration/velocity, lowers gravity)
	if abs(parent.velocity.y) < PlayerData.HANG_THRESHOLD:
		return parent.jump_peak_state
	return null
	
	


#brings back gravity after a certain amount of time if we dont release jump
func _on_fullhop_timer_timeout():
	current_gravity = PlayerData.DEFAULT_GRAVITY
	parent.walljump_state.current_gravity = parent.walljump_state.GRAVITY
	


