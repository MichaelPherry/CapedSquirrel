extends State


@export
var walk_state: State
@export
var jump_state: State
@export
var fall_state: State



func enter() -> void:
	fall_state.can_jump = true
	
	parent.velocity.x = 0
	parent.sprite.play(animation_name)
	return
	
	
func exit() -> void:
	pass
	
func input_step(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_accept"):
		return jump_state
	if Input.get_axis("ui_left", "ui_right") != 0:
		return walk_state
	return null
	
func logic_step(delta) -> State:
	return null
	
func physics_step(delta) -> State:
	parent.velocity.y += parent.DEFAULT_GRAVITY*delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
		
	return null

