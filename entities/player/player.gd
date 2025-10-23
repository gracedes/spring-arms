extends RigidBody2D


const SPEED = 300.0
var arms = []
@export var max_dist = 600.0
@export var spring_coeff = 5
@export var movement_coeff = 5

const jumpkey = 'jump'
@export var jumpforce = -50000.0	# lol
@export var downforce = 1000.0
@export var canjump = false
var just_jumped = false
var needstorque = false
@export var torque_coeff = 200.0

var start_seq = true
var start_init = false
var start_timer = 0.0
@export var start_force = 100000

func _ready() -> void:
	arms = get_tree().get_nodes_in_group('arms')

func _physics_process(delta: float) -> void:
	if start_seq:
		if not start_init:
			if Input.is_action_just_pressed(jumpkey): start_init = true
		elif start_timer <= 1 and Input.is_action_pressed(jumpkey):
			start_timer += delta
			global_position.x -= 100 * delta
		else:
			var f = Vector2.ZERO
			f.x += start_timer * start_force
			start_seq = false
			apply_force(f)
	else:
		check_inputs()
		# apply_force(movement_keys())
		apply_force(sum_arm_forces() + other_forces())
		if needstorque:
			apply_torque(linear_velocity.x * torque_coeff)
			needstorque = false
	""" note: look into bug where spamming jump causes you to lose ability to jump 
		also lack of rotation when swinging """

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
				arm.gpos = shorten(get_global_mouse_position())
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
	if Input.is_action_just_pressed(jumpkey):
		if canjump:
			f.y = jumpforce
			just_jumped = true
			needstorque = true
			#canjump = false
	elif just_jumped and Input.is_action_just_released(jumpkey):
		just_jumped = false
	elif !canjump and !just_jumped and Input.is_action_pressed(jumpkey):
		f.y = downforce
	""" check how to better prevent holding after jump from effecting"""
	return f

func shorten(mpos: Vector2) -> Vector2:
	var relpos = mpos - position
	if relpos.length() > max_dist:
		return (max_dist * relpos.normalized()) + position
	else:
		return relpos + position


func _on_area_2d_body_entered(body: Node2D) -> void:
	canjump = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	canjump = false
