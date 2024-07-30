extends State

var speed = .08


func enter():
	parent.animations.play(animation_name)
	return
	
func exit():
	parent.player.state_machine.change_state(parent.player.state_machine.starting_state)
	pass
	
func input_step(event: InputEvent) -> State:
	return null
	
func logic_step(delta) -> State:
	return null
	
func physics_step(delta) -> State:
	var target_x = parent.target.position.x
	var target_y = parent.target.position.y
	
	var width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var height = ProjectSettings.get_setting("display/window/size/viewport_height")
	
	target_x = clamp(target_x, parent.bounds[SIDE_LEFT]+(width/2), parent.bounds[SIDE_RIGHT]-(width/2))
	target_y = clamp(target_y, parent.bounds[SIDE_TOP]+(height/2), parent.bounds[SIDE_BOTTOM]-(height/2))
	
	parent.position.x = lerp(parent.position.x, target_x, 1.0 - pow(speed, delta))
	parent.position.y = lerp(parent.position.y, target_y, 1.0 - pow(speed, delta))
	
	if (parent.position.x == target_x and parent.position.y == target_y):
		return parent.default_state
		
	
	return null

