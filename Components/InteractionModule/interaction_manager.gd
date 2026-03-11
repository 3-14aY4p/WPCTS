extends Node2D


# change the label location into a
# dedicated HUD (bottom of screen?)

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var label: Label = $Label


var active_areas: Array[InteractionArea] = []
var can_interact: = true


func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	
func register_area(area: InteractionArea):
	active_areas.push_back(area)

func unregister_area(area: InteractionArea):
	active_areas.erase(area)

func _process(delta: float) -> void:
	active_areas = active_areas.filter(func(a): return is_instance_valid(a))
	
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		var nearest = active_areas[0]
		
		label.text = nearest.action_hint
		label.global_position = nearest.global_position
		label.global_position.y -= 32
		label.global_position.x -= label.size.x / 2
		
		label.show()
	else:
		label.hide()

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position) # added the .global_position
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("_interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			can_interact = true
