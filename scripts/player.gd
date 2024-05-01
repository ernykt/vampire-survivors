extends CharacterBody2D

@onready var fire_ball = preload("res://scenes/fire_ball.tscn")
@onready var progress_bar = $"../Control/ProgressBar"
@onready var label = $"../Control/Label"

enum States {IDLE, WALKING}

var level = 0
var SPEED = 600
var state = States.IDLE

func change_state(new_state):
	state = new_state
	
func idle():
	if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		change_state(States.WALKING)
	
func walking():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	if not input_direction:
		change_state(States.IDLE)

func _physics_process(delta):
	label.text = "Level " + str(level)
	var close_enemy = get_closest_enemy()
	match state:
		States.IDLE:
			idle()
		States.WALKING:
			walking()
	move_and_slide()
	
func shoot_fire_ball():
	var fire_ball_instance = fire_ball.instantiate()
	fire_ball_instance.global_position = self.global_position
	var close_enemy = get_closest_enemy()
	if close_enemy:
		var distance_vector = fire_ball_instance.global_position.direction_to(close_enemy.global_position)
		get_tree().root.add_child(fire_ball_instance)
		fire_ball_instance.apply_impulse(distance_vector * fire_ball_instance.fire_ball.travel_speed)
		
func _on_fire_ball_timer_timeout():
	var enemies = get_tree().get_nodes_in_group("enemies")
	#print(enemies)
	if enemies:
		for enemy in enemies:
			if enemy.state != enemy.States.EXP and enemy.state != enemy.States.FOLLOW:
				shoot_fire_ball()
				continue
				
func get_closest_enemy():
	var min_distance = 2147483647 #MAX INTEGER
	var enemies = get_tree().get_nodes_in_group("enemies")
	var close_enemy
	if enemies:
		for enemy in enemies:
			if enemy.state != enemy.States.EXP and enemy.state != enemy.States.FOLLOW:
				var location = self.global_position - enemy.global_position
				var distance = location.length()
				if distance < min_distance:
					min_distance = distance
					close_enemy = enemy
				return close_enemy
		
func _on_area_2d_body_entered(body):
	if "Enemy" in body.name:
		if body.state == body.States.EXP:
			body.change_state(body.States.FOLLOW)
			
func _on_collect_area_body_entered(body):
	if "Enemy" in body.name:
		progress_bar.value += 50 
		if progress_bar.value == progress_bar.max_value:
			progress_bar.max_value = 1.1 * progress_bar.max_value
			progress_bar.value = 0
			level += 1
		body.queue_free()
