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
	pass

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
		if dialogue_label.visible_ratio == 1:
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

func reveal_dialogue(text: String, speed: float):
	dialogue_label.visible_ratio = 0
	dialogue_label.text = text
	
	var tween = create_tween()
	tween.tween_property(dialogue_label, "visible_ratio", 1, speed)
