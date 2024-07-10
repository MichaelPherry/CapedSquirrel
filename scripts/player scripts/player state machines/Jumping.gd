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


func enter():
	#ensure coyote time does not apply if we enter fall state from jump
	parent.fall_state.can_jump = false
	#gravity is zero at start of jump (comes back in after fullhop or on key release)
	current_gravity = 0
	#set y velocity to jump height and add jump boost if we are moving in a direction
	parent.velocity.y = PlayerData.JUMP_VELOCITY
	parent.velocity.x += sign(parent.velocity.x)*PlayerData.JUMP_BOOST
	#set off fullhop timer to bring gravity back if player does not release jump
	fullhop_timer.start(PlayerData.FULLHOP_LENGTH)
	#calculate movement and set target speed
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	
	parent.sprite.play(animation_name)
	
	return
	
func exit():
	fullhop_timer.stop()
	return
	
func input_step(event: InputEvent) -> State:
	#calculate movement and set target speed
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	# bring back gravity of jump key released 
	if Input.is_action_just_released(PlayerData.controls["jump"]):
		current_gravity = PlayerData.DEFAULT_GRAVITY
		fullhop_timer.stop()
	#if we input a jump, buffer in case we land
	if Input.is_action_just_pressed(PlayerData.controls["jump"]):
		jump_buffer_timer.start(PlayerData.JUMP_BUFFER_LENGTH)
		PlayerData.jump_buffered = true
	return null
	

	
func physics_step(delta) -> State:
	
	#calc accel and gravity and update velocities and move character
	var temp_accel = PlayerData.calcTempAccel(target_speed, parent.velocity.x, SPEED, PlayerData.AERIAL_ACCEL_MOD, PlayerData.AIR_DRAG)
	
	parent.velocity.x += temp_accel * delta
	parent.velocity.y += current_gravity * delta
	parent.move_and_slide()
	
	#if player hits a flat ceiling, immediately enter falling state
	#ommitted for now, didnt like how it felt
	
	#for i in parent.get_slide_collision_count():
		#if parent.get_slide_collision(i).get_normal() == Vector2(0, 1):
			#parent.velocity.y = 0
			#return fall_state
	
	
	#otherwise check if our jump has interrupted and we landed 
		#(edit: i dont think this is actually possible since we must be traveling upwards, but its here just in case)
	if parent.is_on_floor():
		if PlayerData.jump_buffered:
			return self
		if parent.velocity.x == 0:
			return parent.idle_state
		else:
			return parent.walk_state
	#finally, enter the jump peak state (increases acceleration/velocity, lowers gravity)
	if abs(parent.velocity.y) < PlayerData.HANG_THRESHOLD:
		return parent.jump_peak_state
	return null
	
	


#brings back gravity after a certain amount of time if we dont release jump
func _on_fullhop_timer_timeout():
	current_gravity = PlayerData.DEFAULT_GRAVITY


