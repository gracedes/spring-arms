extends Sprite2D

@export var max_shift = 30.0
@export var shift_coeff = 0.001

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_parent().get_parent()
	move_to(player.linear_velocity.y, player.rotation)

func move_to(yvelo: float, rot: float) -> void:
	if abs(yvelo) <= 0.5:
		offset.y = move_toward(offset.y, -54.0, 500 * shift_coeff)
	else:
		offset.y = move_toward(offset.y, -54.0 + (max_shift * -(yvelo / abs(yvelo)) * (cos(deg_to_rad(abs(rot))))), min(abs(yvelo) * shift_coeff, 500 * shift_coeff))
	pass
