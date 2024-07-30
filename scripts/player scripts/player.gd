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
var wallcling_state: State
@export
var walljump_state: State
@export
var hooked_state: State

@onready var state_machine = $Player_state_machine

@onready var sprite = $AnimatedSprite2D

@onready var grapple_scene = preload("res://scenes/grapple.tscn")

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
		PlayerData.ignore_accel = false
		if PlayerData.jump_buffered:
			return jump_state
		if Global.is_hooked:
			return hooked_state
		if self.velocity.x == 0:
			return idle_state
		else:
			return walk_state
			
	for i in self.get_slide_collision_count():
		var norm_x = self.get_slide_collision(i).get_normal().x
		if abs(norm_x) == 1:
			PlayerData.ignore_accel = false
			walljump_state.wall_norm = norm_x
			return wallcling_state
				
	return null
	
func _input(event):
	if event is InputEventMouseButton: # or InputEventKey: #or InputEventJoypadButton:
		var grapple = grapple_scene.instantiate()
		if Input.is_action_just_pressed("shoot") and Global.can_hook:
			var dir = get_global_mouse_position() - self.position
			grapple.shoot(dir, self.position)
			add_child(grapple)
		
		else:
			grapple.release()
			var child = get_node("grapple")
			self.remove_child(child)

#unbuffers jump a few frames after we press jump
func _on_jump_buffer_timer_timeout():
	PlayerData.jump_buffered = false
	return
	
	
	


func _on_ignore_accel_timer_timeout():
	PlayerData.ignore_accel = false
