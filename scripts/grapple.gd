extends Node2D

@onready var links = $Links
@onready var tip = $Tip

var direction := Vector2(0,0)	# The direction in which the chain was shot
#var tip := Vector2(0,0)			# The global position the tip should be in

var speed : int = 700
var flying = false

var player_pos

func shoot(direct, pos):
	direction = direct.normalized()
	player_pos = pos
	Global.hook_pos = pos
	#if Global.upRight == true:
	flying = true
	
func release():
	flying = false
	Global.is_hooked = false

func _process(delta):
	if not Global.is_hooked:
		Global.hook_pos += speed * direction * delta
		if abs(Global.hook_pos - player_pos).length() > Vector2(150, 150).length():
				flying = false
				Global.can_hook = false
				self.visible = false
				return
		
	var tip_loc = to_local(Global.hook_pos)
	links.rotation = self.position.angle_to_point(tip_loc) - deg_to_rad(270)
	tip.rotation = self.position.angle_to_point(tip_loc) - deg_to_rad(270)
	links.offset.y = tip_loc.length() / (2 * links.scale.y)
	links.position = tip_loc
	links.region_rect.size.y = tip_loc.length() / links.scale.y
	
func _physics_process(delta):
	tip.global_position = Global.hook_pos
	if flying:
		if tip.move_and_collide(direction):
			Global.is_hooked = true
			flying = false
	Global.hook_pos = tip.global_position
