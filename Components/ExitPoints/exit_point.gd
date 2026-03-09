extends Interactables


@export var point_id: String
@export var scene_uid: String

@export var is_locked: bool = false
@export var is_door: bool = true


func _on_interact():
	if is_locked:
		trigger_dialogue()
	else:
		Global.last_exit_id = point_id
		Global.game_controller.change_2d_scene(scene_uid)

# for non-door areas
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if not is_door:
		Global.last_exit_id = point_id
		Global.game_controller.call_deferred("change_2d_scene", scene_uid)
