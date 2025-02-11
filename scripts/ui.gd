extends Control

@export var tower_scene: PackedScene  # Cena da torre para instanciar
var is_placing_tower: bool = false  # Controla se o jogador está no modo de colocar torre

@export_category("Builder")
@export var button_place_tower : Button

func _ready():
	button_place_tower.pressed.connect(_on_place_tower_pressed)

func _on_place_tower_pressed():
	is_placing_tower = true  # Ativa o modo de posicionar torre
