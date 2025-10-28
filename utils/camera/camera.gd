extends Camera2D

@export var base_pos = Vector2.ZERO
@export var max_pos = Vector2(400.0, 300.0)

@export var base_zoom = 0.75
@export var max_zoom = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_parent()
	var v = player.linear_velocity
	shift_pos(v)
	zoom_out(v)

func shift_pos(v: Vector2) -> Vector2:
	var vp = get_viewport_rect().size * zoom
	
	var temp = 0.0001 * v
	for i in range(2):
		if temp[i] > -1.0:
			v[i] = min(temp[i], 1.0)
		else:
			v[i] = -1.0
	
	return Vector2.ZERO

func zoom_out(v: Vector2) -> void:
	var x = 0.0001 * v.length()
	#print(x, zoom.x)
	if x > 0.25:
		x = 0.25
	var y = move_toward(zoom.x, min(base_zoom, base_zoom - x), 0.001)
	zoom = Vector2(y, y)
	pass
