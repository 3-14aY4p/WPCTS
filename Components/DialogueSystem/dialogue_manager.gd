class_name DialogueManager extends Control


@onready var speaker_name: RichTextLabel = $CanvasLayer/SpeakerParent/SpeakerName
@onready var speaker_anim: AnimatedSprite2D = $CanvasLayer/SpeakerParent/SpeakerSprite
@onready var dialogue_label: RichTextLabel = $CanvasLayer/DialogueBox/DialogueLabel
@onready var button_container: HBoxContainer = $CanvasLayer/DialogueBox/ButtonContainer

@onready var player: Player = get_tree().get_first_node_in_group("player")

var dialogue: Array[DE]
var current_dialogue_item: int = 0
var next_item: bool = true


func _ready() -> void:
	visible = false
	button_container.visible = false

func _process(delta: float) -> void:
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

func _function_resource():
	pass
	
func _choice_resource():
	pass
	
func _text_resource():
	pass

func set_speaker(name: String, anim: String):
	speaker_name.text = name
	speaker_anim.play(anim)

func reveal_dialogue(text: String, speed: float):
	dialogue_label.visible_ratio = 0
	dialogue_label.text = text
	
	var tween = create_tween()
	tween.tween_property(dialogue_label, "visible_ratio", 1, speed)
