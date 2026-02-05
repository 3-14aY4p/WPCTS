class_name InteractionArea extends Area2D


var interaction_manager = Global.interaction_manager
@export var action_hint: String = "[E] Interact"


var interact: Callable = func():
	pass

func _on_body_entered(body: Node2D) -> void:
	interaction_manager.register_area(self)

func _on_body_exited(body: Node2D) -> void:
	interaction_manager.unregister_area(self)
