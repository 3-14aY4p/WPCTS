extends Interactables


@export var point_id: String
@export var scene_uid: String

@export var is_locked: bool = false
@export var is_door: bool = true


func _on_interact():
	if is_locked:
		trigger_dialogue()
	else:
		Global.last_area_id = point_id
		Global.game_controller.change_2d_scene(scene_uid)
