extends Node2D

var grab = false
var gpos = Vector2()
const max_leng = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.get_node('spring').node_b = '../..'
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if grab == true:
		self.get_node('hand').set_global_position(gpos)
		if Input.is_action_just_pressed('leftClick'):
			grab = false
	else:
		if Input.is_action_just_pressed('leftClick'):
			gpos = get_mpos(get_viewport().get_mouse_position())
			grab = true

func get_mpos(mpos: Vector2) -> Vector2:
	var player = self.get_node('..')
	var X = mpos.x - position.x
	var Y = mpos.x - position.y
	var x
	var y
	
	if sqrt((X*X) + (Y*Y)) < max_leng:
		x = X
		y = Y
	else:
		var theta = atan(Y/X)
		x = max_leng*cos(theta)
		y = max_leng*sin(theta)
	return Vector2(player.position.x + x, player.position.y + y)
