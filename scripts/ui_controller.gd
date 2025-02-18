extends Control

signal tower_selected(tower_data: TowerData)

@export var tower_buttons: Array[Button]  # Botões das torres

func _ready():
	for button in tower_buttons:
		button.pressed.connect(_on_tower_button_pressed)

func _on_tower_button_pressed(button):
	var tower_data = button.get_meta("tower_data")  # Supondo que o botão tenha metadados
	emit_signal("tower_selected", tower_data)
