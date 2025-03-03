extends RigidBody2D
var reparented = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('leftClick'):
		if self.freeze == false:
			self.freeze = true
		else:
			self.freeze = false
