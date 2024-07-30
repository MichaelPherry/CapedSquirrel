extends State



func _ready():
	pass

func enter():
	pass
	
func exit():
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
	
	parent.position.x = target_x
	parent.position.y = target_y
	
	
	
	return null

