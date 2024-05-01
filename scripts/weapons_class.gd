extends Node
class_name Weapons

var damage : float
var knockback : float
var travel_speed : float
var level : int

func _init():
	damage = 0.0
	knockback = 0.0
	travel_speed = 0.0
	level = 0

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
