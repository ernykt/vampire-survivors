extends RigidBody2D

var weapon_attributes = Weapons.new()
var enemy_location

func _ready():
	weapon_attributes.damage = 10.0
	weapon_attributes.knockback = 100.0
	weapon_attributes.travel_speed = 500.0
	
func _on_area_2d_body_entered(body):
	if "Enemy" in body.name:
		body.take_damage(weapon_attributes.damage)
		body.change_state(body.States.KNOCKBACK)
		body.velocity = (body.global_position - self.global_position).normalized() * weapon_attributes.knockback
		self.queue_free()
		
func _on_time_to_live_timeout():
	self.queue_free()
