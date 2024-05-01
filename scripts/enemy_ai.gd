extends CharacterBody2D

enum States {WALKING, KNOCKBACK, HURT, DEATH, EXP, FOLLOW}

@export var resource : EnemyResource

@onready var hurt_timer = $HurtTimer

var speed
var health
var direction
var state = States.WALKING

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
	hurt_timer.start(0.25)
	change_state(States.HURT)
	
func walking():
	set_modulate(Color(1,1,1))
	direction = global_position.direction_to(get_tree().get_first_node_in_group("player").global_position)
	velocity = direction * speed
	
func take_damage(damage):
	health -= damage

func _ready():
	speed = resource.movement_speed
	health = resource.health

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
	move_and_slide()
	
func _on_hurt_timer_timeout():
	if state != States.EXP and state != States.FOLLOW :
		change_state(States.WALKING)
	else:
		velocity = Vector2.ZERO
