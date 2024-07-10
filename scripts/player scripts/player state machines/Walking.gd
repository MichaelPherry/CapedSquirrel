extends State

#name for debugging
var state_name = "walking"

#"pointers" to other states, export means set them manually in inspector
@export
var jump_state: State
@export
var fall_state: State
@export
var idle_state: State


#speed for current state (default because we are grounded)
const SPEED = PlayerData.BASE_SPEED


#variable to determine movement
var target_speed = 0


func _ready():
	return

func enter():
	#re-enables coyote time if we fall off a ledge
	fall_state.can_jump = true
	#get movement input
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	#play animation
	parent.sprite.play(animation_name)
	return
	
func exit():
	pass
	
func input_step(event: InputEvent) -> State:
	#get input, jump if jump is pressed
	if Input.is_action_just_pressed(PlayerData.controls["jump"]):
		return jump_state
	var direction = Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"])
	target_speed = direction*SPEED
	if direction != 0:
		#parent.animator.x_scale?? = direction
		#set animation to direction you are trying to move
		return null
	return null
	
func logic_step(delta) -> State:
	return null
	
func physics_step(delta) -> State:
	#calculate acceleration and gravity, update velocity and move
	var temp_accel = PlayerData.calcTempAccel(target_speed, parent.velocity.x, SPEED)

	parent.velocity.x += temp_accel * delta
	parent.velocity.y += PlayerData.DEFAULT_GRAVITY*delta

	parent.move_and_slide()
	if !parent.is_on_floor():
		return fall_state
	if parent.velocity.x == 0:
		return idle_state
		
	return null

