extends ColorRect

@onready var player = get_tree().get_first_node_in_group("player")

var item = null
var mouse_over = false

signal selected_upgrade

func _ready():
	selected_upgrade.connect(gamer)
	
func _input(event):
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade")
	
func _on_mouse_entered():
	mouse_over = true
	print(mouse_over)

func _on_mouse_exited():
	mouse_over = false
	print(mouse_over)

func gamer():
	self.queue_free()
