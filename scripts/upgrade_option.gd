extends ColorRect

@onready var player = get_tree().get_first_node_in_group("player")
@onready var item_name = $ItemName
@onready var item_description = $ItemDescription
@onready var item_level = $ItemLevel
@onready var item_image = $ItemDisplayer/ItemImage

var item = null
var mouse_over = false

signal selected_upgrade(upgrade)

func _ready():
	if item == null:
		item = "food"
	item_name.text = Upgrades.UPGRADES[item]["displayname"]
	item_description.text = Upgrades.UPGRADES[item]["details"]
	item_level.text = Upgrades.UPGRADES[item]["level"]
	#item_image.texture = load(Upgrades.UPGRADES[item]["icon"])
	connect("selected_upgrade", Callable(player, "upgrade_character"))
	
func _input(event):
	if event.is_action_pressed("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item)
	
func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false

func gamer():
	print(self.name)
	self.queue_free()
