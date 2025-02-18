class_name TowerData
extends Resource

@export_category("Status")
@export var name: String
@export var cost: int
@export var health : int 
@export var damage : int
@export var range : float
@export var attack_interval : float
@export var max_targets: int
@export_category("Visual")
@export var sprite: Texture2D  # Caminho para a sprite ou atlas de animação
@export var icon : Texture2D
@export_category("Animation")
@export var sprite_frames: SpriteFrames 
@export var idle_animation: String  # Nome da animação (opcional se usar atlas)
@export var attack_animation: String
@export var take_damage_animation: String
@export var defeat_animation: String
@export var attack_type: String
@export var attack_effect: String

@export_category("Upgrades")
@export var upgrade_options: Array[Dictionary]  # Upgrades possíveis
