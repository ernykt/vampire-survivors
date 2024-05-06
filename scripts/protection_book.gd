extends CharacterBody2D

@onready var path_2d = $"../.."
@onready var path_follow_2d = $".."
@onready var protection_book = $"."

#book attributes
var damage = 5.0
var knockback = 300.0

const SIZE = 500
const NUM_POINTS = 64

func rotate_around():
	pass

func _ready():
	for i in NUM_POINTS:
		path_2d.curve.add_point(Vector2(0, -SIZE).rotated((i / float(NUM_POINTS)) * TAU))
		
	path_2d.curve.add_point(Vector2(0, -SIZE))

func _physics_process(delta):
	path_follow_2d.progress += 300.0 * delta
	move_and_slide()
	
func _on_area_2d_body_entered(body):
	if "Enemy" in body.name:
		body.take_damage(damage)
		body.change_state(body.States.KNOCKBACK)
		body.velocity = (body.global_position - self.global_position).normalized() * knockback
