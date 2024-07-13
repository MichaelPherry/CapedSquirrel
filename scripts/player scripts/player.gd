extends CharacterBody2D


@export
var walk_state: State
@export
var idle_state: State
@export
var jump_peak_state: State
@export
var fall_state: State
@export 
var jump_state: State
@export 
var glide_state: State

@onready var state_machine = $Player_state_machine

@onready var sprite = $AnimatedSprite2D

func _ready():
	state_machine.init(self)

func _unhandled_input(event) -> void:
	state_machine.input_step(event)


func _physics_process(delta):
	state_machine.physics_step(delta)
	

func _process(delta):
	state_machine.logic_step(delta)
	



#unbuffers jump a few frames after we press jump
func _on_jump_buffer_timer_timeout():
	PlayerData.jump_buffered = false
	return
	
	
	
