extends CharacterBody2D

enum States {WALKING, KNOCKBACK, HURT, DEATH, EXP, FOLLOW}

@export var resource : EnemyResource
@export var area2d : Area2D
@export var hurt_timer : Timer
@export var damage_timer : Timer

var speed
var health
var direction
var state = States.WALKING
var damage
var bodies

func follow_state():
	direction = global_position.direction_to(get_tree().get_first_node_in_group("player").global_position)
	velocity = direction * speed * 2

func exp_state():
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(4, true)
	set_collision_mask_value(4, true)
	set_modulate(Color(1,1,1))
	self.scale = Vector2(0.5, 0.5)
	
func change_state(new_state):
	#print(States.keys()[state])
	state = new_state
	
func hurt_state():
	set_modulate(Color("Red"))
	if health <= 0:
		change_state(States.EXP)

func knockBack_state():
	hurt_timer.start(0.5)
	change_state(States.HURT)
	
func walking():
	set_modulate(Color(1,1,1))
	direction = global_position.direction_to(get_tree().get_first_node_in_group("player").global_position)
	velocity = direction * speed
	
func take_damage(dmg):
	health -= dmg

func _ready():
	speed = resource.movement_speed
	health = resource.health
	damage = resource.damage
	
func _physics_process(_delta):
	match state:
		States.WALKING:
			walking()
		States.KNOCKBACK:
			knockBack_state()
		States.HURT:
			hurt_state()
		States.DEATH:
			self.queue_free()
		States.EXP:
			exp_state()
		States.FOLLOW:
			follow_state()

	bodies = area2d.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			if damage_timer.is_stopped():
				body.health -= damage 
				body.health_bar.value -= damage
				damage_timer.start(1.5)
				
	move_and_slide()

func _on_hurt_timer_timeout():
	if state != States.EXP and state != States.FOLLOW :
		change_state(States.WALKING)
	else:
		velocity = Vector2.ZERO
