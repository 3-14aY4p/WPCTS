class_name DialogueManager extends Control


@onready var speaker_name: RichTextLabel = $CanvasLayer/NinePatchRect/SpeakerName
@onready var speaker_parent: Control = $CanvasLayer/HBoxContainer/SpeakerParent
@onready var speaker_anim: AnimatedSprite2D = $CanvasLayer/HBoxContainer/SpeakerParent/SpeakerSprite
@onready var dialogue_label: RichTextLabel = $CanvasLayer/HBoxContainer/TextBox/DialogueLabel
@onready var button_container: HBoxContainer = $CanvasLayer/HBoxContainer/TextBox/ButtonContainer
@onready var indicator: AnimatedSprite2D = $CanvasLayer/NinePatchRect/Indicator

@onready var player: Player = get_tree().get_first_node_in_group("player")

var dialogue: Array[DE]
var current_dialogue_item: int = 0
var next_item: bool = true

var total_char


func _ready() -> void:
	visible = false
	button_container.visible = false

func _process(delta: float) -> void:
	if current_dialogue_item >= dialogue.size():
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

func _function_resource(i: DialogueFunction):
	pass

func _choice_resource(i: DialogueChoice):
	dialogue_label.text = i.text
	dialogue_label.visible_characters = -1
	
	if not i.speaker_anim:
		speaker_parent.visible = false
		speaker_name.visible = false
		dialogue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	else:
		speaker_name.text = i.speaker_name
		speaker_anim.play(i.speaker_anim)
	button_container.visible = true
	
	for item in i.choice_text.size():
		var dialogue_button = preload("uid://duwv6yl4tc7by")
		var dialogue_button_instance = dialogue_button.instantiate()
		dialogue_button_instance.text = i.choice_text[item]
		
		var function_resource: DialogueFunction = i.choice_function_call[item]
		if function_resource:
			dialogue_button_instance.connect("pressed",
			Callable(get_node(function_resource.target_path), 
			(function_resource.function_name)).bindv(function_resource.function_arguments),
			CONNECT_ONE_SHOT)
			if function_resource.hide_dialogue_box:
				dialogue_button_instance.connect("pressed", hide, CONNECT_ONE_SHOT)
				
			dialogue_button_instance.connect("pressed",
			_choice_button_pressed.bind(get_node(function_resource.target_path), 
			function_resource.wait_for_signal_to_continue),
			CONNECT_ONE_SHOT)
		else:
			dialogue_button_instance.connect("pressed", _choice_button_pressed.bind(null, ""), CONNECT_ONE_SHOT)
		
		button_container.add_child(dialogue_button_instance)
	#button_container.get_child(0).grab_focus()

func _text_resource(i: DialogueText):
	if not i.speaker_anim:
		speaker_parent.visible = false
		speaker_name.visible = false
		dialogue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	else:
		speaker_name.text = i.speaker_name
		speaker_anim.play(i.speaker_anim)
		
	reveal_dialogue(i.text, i.text_speed)
	while true:
		await get_tree().process_frame
		
		if dialogue_label.visible_characters == total_char:
			#var timer = Timer.new()
			#add_child(timer)
			#
			#timer.start(1)
			#timer.connect("timeout", indicator.show)
			
			indicator.show()
			if Input.is_action_just_pressed("_interact"):
				#timer.queue_free()
				indicator.hide()
				current_dialogue_item += 1
				next_item = true



func _choice_button_pressed(target_node: Node, wait_for_signal_to_continue: String):
	button_container.visible = false
	for i in button_container.get_children():
		i.queue_free()
	
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

func reveal_dialogue(text: String, speed: float):
	dialogue_label.text = text
	dialogue_label.visible_characters = 0
	
	var bbc_text = _extract_bbcode(text)
	total_char = bbc_text.length()
	
	var typing_time: float = 0.0
	
	while dialogue_label.visible_characters < total_char:
		if Input.is_action_just_pressed("_skip_dialogue") or speed == 0:
			dialogue_label.visible_characters = total_char
			break
		
		typing_time += get_process_delta_time()
		if typing_time >= (1.0/speed) or bbc_text[dialogue_label.visible_characters] == " ":
			var character: String = bbc_text[dialogue_label.visible_characters]
			dialogue_label.visible_characters += 1
		
		dialogue_label.visible_characters = speed * typing_time as int
		
		await get_tree().process_frame

#[] -> sign of BBCode; we don't want them included in the char visible count
func _extract_bbcode(text: String) -> String:
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
