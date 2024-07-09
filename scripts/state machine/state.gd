class_name State
extends Node


@export
var animation_name: String

var parent

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func input_step(event: InputEvent) -> State:
	return null
	
func logic_step(delta: float) -> State:
	return null
	
func physics_step(delta: float) -> State:
	return null
