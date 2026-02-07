class_name DialogueSystem extends Node2D


const DialogueButtonPreload = preload("res://Components/DialogueSystem/dialogue_button.tscn")

@onready var speaker_name: RichTextLabel = $HBoxContainer/SpeakerParent/RichTextLabel
@onready var speaker_sprite: Sprite2D = $HBoxContainer/SpeakerParent/Sprite2D
@onready var dialogue_label: RichTextLabel = $HBoxContainer/VBoxContainer/RichTextLabel

@onready var speaker_parent: Control = $HBoxContainer/SpeakerParent
@onready var button_container: HBoxContainer = $HBoxContainer/VBoxContainer/ButtonContainer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var dialogue: Array[DE]
var current_dialogue_item: int = 0
var next_item: bool = true

@onready var player: Player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	visible = false
	button_container.visible = false

func _process(_delta: float) -> void:
	if current_dialogue_item == dialogue.size():
		player.state_machine.change_state("playeridle")
		
		queue_free()
		return
	
	if next_item:
		next_item = false
		var i = dialogue[current_dialogue_item]
		
		if i is DialogueFunction:
			if i.hide_dialogue_box:
				visible = false
			else:
				visible = true
			_function_resource(i)
		
		elif i is DialogueChoice:
			visible = true
			_choice_resource(i)
		
		elif i is DialogueText:
			visible = true
			_text_resource(i)
		
		else:
			printerr("Accidentally added a DE resource.")
			current_dialogue_item += 1
			next_item = true

func _function_resource(i: DialogueFunction) -> void:
	var target_node = get_node(i.target_path)
	if target_node.has_method(i.function_name):
		if i.function_arguments.size() == 0:
			target_node.call(i.function_name)
		else:
			target_node.callv(i.function_name, i.function_arguments)
	
	if i.wait_for_signal_to_continue:
		var signal_name = i.wait_for_signal_to_continue
		if target_node.has_signal(signal_name):
			var signal_state = {"done": false} # using dict because lambpassda functions
			var callable = func(_args): signal_state.done = true
			target_node.connect(signal_name, callable, CONNECT_ONE_SHOT)
			while not signal_state.done:
				await get_tree().process_frame
	
	current_dialogue_item += 1
	next_item = true

func _choice_resource(i: DialogueChoice) -> void:
	speaker_name.text = i.speaker_name
	dialogue_label.text = i.text
	dialogue_label.visible_characters = -1
	
	if i.speaker_img:
		speaker_parent.visible = true
		speaker_sprite.texture = i.speaker_img
		speaker_sprite.hframes = i.speaker_img_Hframes
		speaker_sprite.frame = min(i.speaker_img_select_frame, i.speaker_img_Hframes - 1)
	else:
		speaker_parent.visible = false
	button_container.visible = true
	
	for item in i.choice_text.size():
		var dialogue_button_instance = DialogueButtonPreload.instantiate()
		dialogue_button_instance.text = i.choice_text[item]
		
		var function_resource: DialogueFunction = i.choice_function_call[item]
		if function_resource:
			dialogue_button_instance.connect("pressed",
			Callable(get_node(function_resource.target_path), (function_resource.function_name)).bindv(function_resource.function_arguments),
			CONNECT_ONE_SHOT)
			if function_resource.hide_dialogue_box:
				dialogue_button_instance.connect("pressed", hide, CONNECT_ONE_SHOT)
				
			dialogue_button_instance.connect("pressed",
			_choice_button_pressed.bind(get_node(function_resource.target_path), function_resource.wait_for_signal_to_continue),
			CONNECT_ONE_SHOT)
		else:
			dialogue_button_instance.connect("pressed", _choice_button_pressed.bind(null, ""), CONNECT_ONE_SHOT)
		
		button_container.add_child(dialogue_button_instance)
	button_container.get_child(0).grab_focus()

func _choice_button_pressed(target_node: Node, wait_for_signal_to_continue: String):
	button_container.visible = false
	for i in button_container.get_children():
		i.queue_free()
		
	#can add AudioStreamPlayer jere
	
	if wait_for_signal_to_continue:
		var signal_name = wait_for_signal_to_continue
		if target_node.has_signal(signal_name):
			var signal_state = {"done": false}
			var callable = func(_args): signal_state.done = true
			target_node.connect(signal_name, callable, CONNECT_ONE_SHOT)
			while not signal_state.done:
				await get_tree().process_frame
	
	current_dialogue_item += 1
	next_item = true

func _text_resource(i: DialogueText) -> void:
	speaker_name.text = i.speaker_name
	audio_stream_player.stream = i.text_sound
	audio_stream_player.volume_db = i.text_volume_db
	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera and i.camera_position != Vector2(999.999, 999.999):
		var camera_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
		camera_tween.tween_property(camera, "global_position", i.camera_position, i.camera_transition_time)
		
	if !i.speaker_img:
		speaker_parent.visible = false
	else:
		speaker_parent.visible = true
		speaker_sprite.texture = i.speaker_img
		speaker_sprite.hframes = i.speaker_img_Hframes
		speaker_sprite.frame = 0
	
	dialogue_label.visible_characters = 0
	dialogue_label.text = i.text
	
	var text_without_square_brackets: String = _text_without_square_brackets(i.text)
	var total_characters: int = text_without_square_brackets.length()
	var character_timer: float = 0.0
	
	while dialogue_label.visible_characters < total_characters:
		#skipping dialogue
		if Input.is_action_just_pressed("_interact"):
			dialogue_label.visible_characters = total_characters
			break
		
		#time in between showing each character/letter
		character_timer += get_process_delta_time()
		if character_timer >= (1.0/i.text_speed) or text_without_square_brackets[dialogue_label.visible_characters] == " ":
			var character: String = text_without_square_brackets[dialogue_label.visible_characters]
			dialogue_label.visible_characters += 1
			if character != " ":
				pass

#[] -> sign of BBCode; we don't want them included in the char visible count
func _text_without_square_brackets(text: String) -> String:
	var result: String = ""
	var inside_bracket: bool = false
	
	for i in text:
		if i == "[":
			inside_bracket = true
			continue #continues the for loop, skipping the code below(?)
		if i == "]":
			inside_bracket = false
			continue
		
		if !inside_bracket:
			result += i
		
	return result
