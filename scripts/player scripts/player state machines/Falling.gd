extends State

#"pointers" to timers
@onready var coyote_timer = $"../../coyote_timer"
@onready var jump_buffer_timer = $"../../jump_buffer_timer"


#name for debugging
var state_name = "falling"

#top speed for given state (base speed since falling and running have same speed(could be changed if we wanted)
const SPEED = PlayerData.BASE_SPEED


#increased gravity during fall
const GRAV_MOD = 1.6
var GRAVITY = PlayerData.DEFAULT_GRAVITY*GRAV_MOD
#maximum fall speed (maybe implement a feature where this is increased when holding down, i know celeste does this)
const MAX_FALL_SPEED = 300

#variable that is only true if we have just left the walking or idle state, and only remains true for "coyote_time_length" number of frames
var can_jump = false
var target_speed = 0


func enter():
	#when we have just entered fall, set a timer to remove our jump after a short duration (5ish frames)
	#note if we are coming from the jump/jump peak states, can_jump will already be false so this timer effectively does nothing in this situation
	coyote_timer.start(PlayerData.COYOTE_TIME_LENGTH)
	
	#get movement input
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	#play the falling animation (not yet implemented all states still have "idle" track as their animation)
	parent.sprite.play(animation_name)
	return
	
	
func exit():
	coyote_timer.stop()
	return
	
func input_step(event: InputEvent) -> State:
	#get movement and jump inputs, if jumped and still in coyote time, enter jump, otherwise buffer jump 
	if Input.is_action_just_pressed(PlayerData.controls["jump"]):
		if can_jump:
			return parent.jump_state
		else:
			jump_buffer_timer.start(PlayerData.JUMP_BUFFER_LENGTH)
			PlayerData.jump_buffered = true
	if Input.is_action_just_pressed(PlayerData.controls["glide"]):
		return parent.glide_state
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	return null
	
	
func physics_step(delta) -> State:
	#calculate acceleration and update velocities
	var temp_accel = PlayerData.calcTempAccel(target_speed, parent.velocity.x, SPEED, PlayerData.AERIAL_ACCEL_MOD, PlayerData.AIR_DRAG)
	
	parent.velocity.x += (temp_accel * delta*PlayerData.accel_modifier)
	parent.velocity.y += GRAVITY*delta
	#ensure we dont pass max fall speed
	if parent.velocity.y > MAX_FALL_SPEED:
		parent.velocity.y = MAX_FALL_SPEED
	#move player and slide against walls and ceilings
	parent.move_and_slide()
	return parent.handle_air_collision()



func _on_coyote_timer_timeout():
	can_jump = false
	




