extends State

#name for debugging
var state_name = "hooked"

#top speed for given state (base speed since falling and running have same speed(could be changed if we wanted)
const SPEED = PlayerData.BASE_SPEED
#increased gravity during fall
const GRAV_MOD = 1.6
var GRAVITY = PlayerData.DEFAULT_GRAVITY*GRAV_MOD
#maximum fall speed (maybe implement a feature where this is increased when holding down, i know celeste does this)

const CHAIN_PULL = 30
var chain_velocity := Vector2(0,0)

var target_speed = 0

func enter() -> void:
	Global.can_hook = false
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	#play the falling animation (not yet implemented all states still have "idle" track as their animation)
	parent.sprite.play(animation_name)
	return
	
func exit() -> void:
	return
	
func input_step(event: InputEvent) -> State:
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"]) 
	#direction += Input.get_axis(PlayerData.controls["up"], PlayerData.controls["down"])
	target_speed = direction*SPEED
	return null
	
func logic_step(delta: float) -> State:
	return null
	
func physics_step(delta: float) -> State:
	
	chain_velocity = parent.to_local(Global.hook_pos).normalized() * CHAIN_PULL
	if chain_velocity.y > 0:
		chain_velocity.y *= 0.35
	else:
		chain_velocity.y *= 1.65

	parent.velocity += chain_velocity
	
	var temp_accel = PlayerData.calcTempAccel(target_speed, parent.velocity.x, SPEED)
	parent.velocity.y += PlayerData.DEFAULT_GRAVITY*delta
	parent.move_and_slide()
	
	if not Global.is_hooked:
		if !parent.is_on_floor():
			return parent.fall_state
		if parent.is_on_floor():
			return parent.idle_state
	return null
