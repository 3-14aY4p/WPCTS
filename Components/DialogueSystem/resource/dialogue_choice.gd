class_name DialogueChoice extends DialogueItem

@export var speaker_name: String
@export var speaker_anim: String

@export_multiline var text: String

@export var choice_text: Array[String]
@export var choice_function_call: Array[DialogueFunction]
