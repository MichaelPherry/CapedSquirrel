extends Node2D

#@onready var links = $Tip/Links

var direction : Vector2
var speed : int = 700
var flying = false

func shoot(direct, pos):
	direction = direct.normalized()
	flying = true
	Global.hook_pos = pos
	
func release():
	flying = false
	Global.is_hooked = false

func _process(delta):
	
	if not Global.is_hooked:
		Global.hook_pos += speed * direction * delta
	
func _physics_process(delta):
	$Tip.global_position = Global.hook_pos
	if flying:
		if $Tip.move_and_collide(direction):
			Global.is_hooked = true
			flying = false
	Global.hook_pos = $Tip.global_position
