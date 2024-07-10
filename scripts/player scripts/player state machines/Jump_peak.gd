extends State

#name for debugging
var state_name = "jump_peak"
#"pointer" to timer
@onready var jump_buffer_timer = $"../../jump_buffer_timer"

#"pointers" to different states (set in inspector)
@export
var walk_state: State
@export
var idle_state: State
@export
var fall_state: State
@export
var jump_state: State


#multipliers to increase velocity/acceleration respectively
const ACCEL_MOD = 1.5
const VEL_MOD = 1.35
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
	
	#if player hits a flat ceiling, immediately enter falling state
	#ommitted cuz it didnt feel good
	#for i in parent.get_slide_collision_count():
		#if parent.get_slide_collision(i).get_normal() == Vector2(0, 1):
			#parent.velocity.y = 0
			#return fall_state
			
	#otherwise check if our jump has interrupted and we landed 
		#(edit: i dont think this is actually possible since we must be traveling upwards, but its here just in case)
	if parent.is_on_floor():
		if PlayerData.jump_buffered:
			return jump_state
		if parent.velocity.x == 0:
			return idle_state
		else:
			return walk_state
	#finally, enter the fall state if we are traveling fast enough
	if parent.velocity.y > PlayerData.HANG_THRESHOLD:
		return fall_state
		
	return null
	



