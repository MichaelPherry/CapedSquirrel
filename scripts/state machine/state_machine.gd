extends Node

@export 
var starting_state: State
var current_state: State


func init(parent: Object) -> void:
	for child in get_children():
		child.parent = parent
	change_state(starting_state)
	
	
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
		
	current_state = new_state
	current_state.enter()
	print(current_state)
	
func physics_step(delta: float) -> void:
	var new_state = current_state.physics_step(delta)
	if new_state:
		change_state(new_state)
		
func logic_step(delta: float) -> void:
	var new_state = current_state.logic_step(delta)
	if new_state:
		change_state(new_state)
	
func input_step(event: InputEvent) -> void:
	var new_state = current_state.input_step(event)
	if new_state:
		change_state(new_state)
	
