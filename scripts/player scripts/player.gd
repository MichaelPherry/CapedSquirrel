extends CharacterBody2D




@onready var state_machine = $Player_state_machine

@onready var sprite = $AnimatedSprite2D

const SPEED = 80
const ACCELERATION = .88
const VEL_POW = 1.3

var DEFAULT_GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")*1.1


var frame_rate = 60

var JUMP_BUFFER_LENGTH = 4/frame_rate

func _ready():
	state_machine.init(self)

func _unhandled_input(event) -> void:
	state_machine.input_step(event)


func _physics_process(delta):
	state_machine.physics_step(delta)
	

func _process(delta):
	state_machine.logic_step(delta)


