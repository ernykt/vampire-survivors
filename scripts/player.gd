extends CharacterBody2D

@onready var fire_ball = preload("res://scenes/fire_ball.tscn")
@onready var upgrade = preload("res://scenes/upgrade_option.tscn")
@onready var progress_bar = $Control/ProgressBar
@onready var label = $Control/Label
@onready var health_bar = $HealthBar
@onready var gui = $GUI
@onready var upgrade_options = $GUI/LevelPanel/UpgradeOptions
@onready var new_func_tester = $Attack/NewFuncTester
@onready var player_sprite = $PlayerSprite

enum States {IDLE, WALKING}

#player stats
var health = 100
var level = 0
var SPEED = 600
var state = States.IDLE
var collected_upgrades : Array
var collected_weapons : Array

#fireball stats
var fireball_upgrade = 0

signal level_up

func _ready():
	level_up.connect(player_level_up)
	collected_weapons.append(fire_ball)

func _physics_process(_delta):
	label.text = "Level " + str(level)
	match state:
		States.IDLE:
			idle()
		States.WALKING:
			walking()
	robust_shoot()
	move_and_slide()

func change_state(new_state):
	state = new_state
	
func idle():
	player_sprite.play("idle")
	if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		change_state(States.WALKING)
	
func walking():
	player_sprite.play("walk")
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if input_direction == Vector2.LEFT:
		player_sprite.flip_h = true
	if input_direction == Vector2.RIGHT:
		player_sprite.flip_h = false
	velocity = input_direction * SPEED
	if not input_direction:
		change_state(States.IDLE)
		
#func shoot_fire_ball():
#	var fire_ball_instance = fire_ball.instantiate()
#	fire_ball_instance.global_position = self.global_position
#	var close_enemy = get_closest_enemy()
#	if close_enemy:
#		var distance_vector = fire_ball_instance.global_position.direction_to(close_enemy.global_position)
#		get_tree().root.add_child(fire_ball_instance)
#		fire_ball_instance.fire_ball.damage += fireball_upgrade
#		print(fire_ball_instance.fire_ball.damage)
#		fire_ball_instance.apply_impulse(distance_vector * fire_ball_instance.fire_ball.travel_speed)
		
#func _on_fire_ball_timer_timeout():
#	var enemies = get_tree().get_nodes_in_group("enemies")
#	#print(enemies)
#	if enemies:
#		for enemy in enemies:
#			if enemy.state != enemy.States.EXP and enemy.state != enemy.States.FOLLOW:
#				shoot_fire_ball()
#				break
				
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
		if body.state == body.States.FOLLOW:
			progress_bar.value += 50 
			if progress_bar.value == progress_bar.max_value:
				progress_bar.max_value = 2 * progress_bar.max_value
				progress_bar.value = 0
				emit_signal("level_up")
			body.queue_free()

func player_level_up():
	print("level up!")
	level += 1
	gui.visible = true
	get_tree().paused = true
	var max_options = 3
	var option_count = 0
	while option_count < max_options:
		var option_instance = upgrade.instantiate()
		var size = Upgrades.UPGRADES.size()
		var random_key = Upgrades.UPGRADES.keys()[randi() % size]
		option_instance.item = random_key
		upgrade_options.add_child(option_instance)
		option_count += 1

func upgrade_character(upgrd):
	var option_children = upgrade_options.get_children()
	for child in option_children:
		child.queue_free()
	match upgrd:
		"food":
			health_bar.value += 20
			health += 20
		"fireball1":
			fireball_upgrade += 5
	gui.visible = false
	get_tree().paused = false
	
func robust_shoot():
	for weapon in collected_weapons:
		var path = weapon.get_path()
		var weapon_name = path.right(-path.rfind("/") - 1).left(-5)
		match weapon_name:
			"fire_ball":
				if new_func_tester.is_stopped():
					general_shoot(weapon, weapon_name)
					new_func_tester.start(.75)
				
func general_shoot(weapon_instance, weapon_name):
	var weapon = weapon_instance.instantiate()
	weapon.global_position = self.global_position
	var close_enemy = get_closest_enemy()
	if close_enemy:
		var distance_vector = weapon.global_position.direction_to(close_enemy.global_position)
		#rotate the fireball according to enemy
		weapon.rotate(self.global_position.angle_to_point(close_enemy.global_position))
		get_tree().root.add_child(weapon)
		match weapon_name:
			"fire_ball":
				weapon.weapon_attributes.damage += fireball_upgrade
		weapon.apply_impulse(distance_vector * weapon.weapon_attributes.travel_speed)
		
