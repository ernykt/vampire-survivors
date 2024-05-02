extends Node2D

@onready var enemy = preload("res://scenes/basic_enemy.tscn")

func _on_timer_timeout():
	var rng = RandomNumberGenerator.new()

	$Path2D/PathFollow2D.progress = rng.randi_range(0, 5200)
	var enemy_instance = enemy.instantiate()
	enemy_instance.global_position = $Path2D/PathFollow2D/Marker2D.global_position
	print(enemy_instance.global_position)
	get_tree().root.add_child(enemy_instance, true)
