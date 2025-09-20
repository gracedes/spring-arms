extends RigidBody2D


const SPEED = 300.0
var arms = []
@export var max_dist = 600.0
@export var spring_coeff = 5
@export var movement_coeff = 5

const jumpkey = 'jump'
@export var jumpforce = -7500.0	# lol
@export var downforce = 1000.0
@export var canjump = false

func _ready() -> void:
	arms = get_tree().get_nodes_in_group('arms')

func _physics_process(delta: float) -> void:
	"""# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()"""
	check_inputs()
	# apply_force(movement_keys())
	apply_force(sum_arm_forces() + other_forces())

func check_inputs() -> void:
	for arm in arms:
		if arm.grab == true:
			arm.get_node('hand').set_global_position(arm.gpos)
			# arm.get_node('hand').set_global_position(global_position + (max_dist*Vector2.RIGHT).rotated(global_position.angle_to_point(arm.gpos)))
			if Input.is_action_just_pressed(arm.key):
				arm.grab = false
				arm.get_node('hand').visible = false
		else:
			if Input.is_action_just_pressed(arm.key):
				arm.gpos = shorten(get_viewport().get_mouse_position())
				arm.grab = true
				arm.get_node('hand').visible = true

func movement_keys() -> Vector2:
	var dir = Vector2.ZERO
	var hdir := Input.get_axis('ui_left', 'ui_right')
	dir.x = hdir * movement_coeff
	return dir

func sum_arm_forces() -> Vector2:
	var f = Vector2.ZERO
	for arm in arms:
		if arm.get_node('hand').visible:
			var agpos = arm.get_node('hand').global_position
			var sgpos = global_position
			
			var dist = sgpos.distance_to(agpos)
			var angle = sgpos.angle_to_point(agpos)
			
			f += spring_coeff*(agpos-sgpos)
	return f

func other_forces() -> Vector2:
	var f = Vector2.ZERO
	if Input.is_action_pressed(jumpkey):
		if canjump:
			f.y = jumpforce
		else:
			f.y = downforce
	return f

func shorten(mpos: Vector2) -> Vector2:
	var relpos = mpos - position
	if relpos.length() > max_dist:
		return (max_dist * relpos.normalized()) + position
	else:
		return relpos + position


func _on_area_2d_body_entered(body: Node2D) -> void:
	canjump = true
	print("body entered!")


func _on_area_2d_body_exited(body: Node2D) -> void:
	canjump = false
	print("body exited!")
