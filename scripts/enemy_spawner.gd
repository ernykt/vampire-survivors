extends Node2D

@onready var enemy = preload("res://scenes/basic_enemy.tscn")
@onready var player = preload("res://scenes/player.tscn")

func _ready():
	randomize()

func _on_spawn_timer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$Path2D/PathFollow2D.progress_ratio = rng.randf_range(0, 1)
	var instance = enemy.instantiate()
	instance.global_position = $Path2D/PathFollow2D/Marker2D.global_position
	get_tree().root.add_child(instance, true)

