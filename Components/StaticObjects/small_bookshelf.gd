extends StaticBody2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player: Player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	print("read")
