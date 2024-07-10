extends State


#name for debugging
var state_name = "idle"

func enter() -> void:
	#ensure coyote_time if we enter fall state next
	parent.fall_state.can_jump = true
	#zero velocity and play animation
	parent.velocity.x = 0
	parent.sprite.play(animation_name)
	return
	
	
func exit() -> void:
	pass
	
func input_step(event: InputEvent) -> State:
	#get input, enter jump state if jumped or walk state if no jump and a movement key is pressed
	if Input.is_action_just_pressed(PlayerData.controls["jump"]):
		return parent.jump_state
	if Input.get_axis(PlayerData.controls["left"], PlayerData.controls["right"]) != 0:
		return parent.walk_state
	return null
	
	
func physics_step(delta) -> State:
	#add gravity and move character
	parent.velocity.y += PlayerData.DEFAULT_GRAVITY*delta
	parent.move_and_slide()
	
	#if we end up off the floor (for example object pushes us off platform while we're in idle) enter fall state
	if !parent.is_on_floor():
		return parent.fall_state
		
	return null

