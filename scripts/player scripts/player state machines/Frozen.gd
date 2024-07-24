extends State



func enter() -> void:
	parent.sprite.pause()
	return
	
func exit() -> void:
	pass
	
func input_step(event: InputEvent) -> State:
	return null
	
func logic_step(delta: float) -> State:
	return null
	
func physics_step(delta: float) -> State:
	return null
