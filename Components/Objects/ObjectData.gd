class_name ObjectData extends Resource


@export var object_name: String = ""
@export var sprite: AtlasTexture

@export_range(0.1, 5, 0.1) var object_mass: float = 0.1
@export var material: PhysicsMaterial
@export var damp_mode: int = 1 #0 = combine; 1 = replace
@export_range(0.1, 100, 0.1) var damp: float = 0.1
