extends RigidBody2D

var fire_ball = Weapons.new()
var enemy_location

func _ready():
	fire_ball.damage = 10.0
	fire_ball.knockback = 100.0
	fire_ball.travel_speed = 500.0

func _on_area_2d_body_entered(body):
	if "Enemy" in body.name:
		body.take_damage(fire_ball.damage)
		body.change_state(body.States.KNOCKBACK)
		body.velocity = (body.global_position - self.global_position).normalized() * fire_ball.knockback
		self.queue_free()
		
func _on_time_to_live_timeout():
	self.queue_free()
