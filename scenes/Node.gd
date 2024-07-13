extends State



func enter():
	parent.animations.play(animation_name)
	return
	
func exit():
	pass
	
func input_step(event: InputEvent) -> State:
	return null
	
func logic_step(delta) -> State:
	return null
	
func physics_step(delta) -> State:
	return null

