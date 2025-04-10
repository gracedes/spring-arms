extends Node2D

@export var key: String
var grab = false
var gpos = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node('hand').visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node('hand').look_at(get_parent().global_position)
