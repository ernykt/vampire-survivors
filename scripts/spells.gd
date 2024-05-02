extends Node

#firball stats
var fireball_damage
var fireball_travel_speed

var collected_weapons : Array
var ice_spear_timer : Timer
var fireball_timer : Timer

func test():
	for weapon in collected_weapons:
		match weapon:
			"icespear":
				if ice_spear_timer.is_stopped():
					var weapon_instance = weapon.instantiate()
					ice_spear_timer.start(2.5)
			"fireball":
				if ice_spear_timer.is_stopped():
					var weapon_instance = weapon.instantiate()
					ice_spear_timer.start(2.5)


