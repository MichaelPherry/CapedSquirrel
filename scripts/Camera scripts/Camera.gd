extends Camera2D

#CAMERA SCENE, SOMEWHAT COMPLETE
#the idea as of now, is that the camera will "stick" to the player (follows precisely and updates each frame)
#will add a "transition area" scene which when entered from the left/right/bottom (easy to do with 1 way collision), it will emit a custom "transition" signal to the camera
#this will temporarily freeze the player (we probably also need to freeze grapple) change the cameras state to transition, while updating the boundaries of the next room (depends on each checkpoint, would be like an export variable or something you set for each transition area)
#when the camera is in transition mode, it will smoothly move towards the edge of the next room while trying to focus on the player, once it stops, we know the transition is complete and we can "unfreeze" the player

@export 
var target: Node2D

@export
var player: CharacterBody2D

@onready
var state_machine = $Camera_state_machine

@export
var default_state: State
@export
var transition_state: State


var bounds = Global.starting_bounds


func _ready():
	set_zoom(Global.default_zoom)
	state_machine.init(self)
	

func _unhandled_input(event) -> void:
	state_machine.input_step(event)


func _physics_process(delta):
	
	state_machine.physics_step(delta)
	

func _process(delta):
	state_machine.logic_step(delta)
	
	
func _on_transition_signal(new_bounds):
	bounds = new_bounds
	player.state_machine.change_state(player.frozen_state)
	state_machine.change_state(transition_state)
	
