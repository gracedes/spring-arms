extends Node2D

var grab = false
var gpos = Vector2()

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
			grab = true
			gpos = get_viewport().get_mouse_position()
