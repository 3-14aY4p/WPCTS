class_name DialogueFunction extends DE

@export var target_path: NodePath #node with the function
@export var function_name: String
@export var function_arguments: Array

@export var hide_dialogue_box: bool #hide during function call
@export var wait_for_signal_to_continue: String = "" #signal to await
