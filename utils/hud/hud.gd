extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_node("../rplayer")
	var v = player.linear_velocity
	var cam = player.get_node("Camera")
	var zoom = cam.zoom
	var cam_pos_scale = cam.position / (cam.get_viewport_rect().size * zoom)
	
	$testinfo.text = "velocity: " + str(v) + "\ncam pos: " + str(cam_pos_scale) + "\ncam zoom: " + str(zoom)
