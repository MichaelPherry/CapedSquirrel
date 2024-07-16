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
@export
var walljump_state: State

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
	

func handle_air_collision():
	

	
	#otherwise check if our jump has interrupted and we landed 
		#(edit: i dont think this is actually possible since we must be traveling upwards, but its here just in case)
	if self.is_on_floor():
		jump_state.wall_jump = 0
		jump_state.jump_modifier = 1
		jump_state.jump_boost_modifier = 1
		
		PlayerData.accel_modifier = 1
		if PlayerData.jump_buffered:
			return jump_state
		if self.velocity.x == 0:
			return idle_state
		else:
			return walk_state
			
	for i in self.get_slide_collision_count():
		var norm_x = self.get_slide_collision(i).get_normal().x
		if abs(norm_x) == 1:
			jump_state.wall_jump = norm_x
			return walljump_state
				
	return null
	

#unbuffers jump a few frames after we press jump
func _on_jump_buffer_timer_timeout():
	PlayerData.jump_buffered = false
	return
	
	
	
