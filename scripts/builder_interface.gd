extends Control

signal tower_selected(tower_data: TowerData)

@export var tower_buttons: Array[Button]  # Botões das torres
@export var tower_builder_controller : TileMapLayer

func _ready():
	for button in tower_buttons:
		button.tower_selected.connect(_on_tower_selected)

func _on_tower_selected(tower_data):
	# Recebe o TowerData do botão clicado
	tower_builder_controller.start_placing_tower(tower_data)
