extends Node2D

@export var color: Color = Color(0, 0, 1, 0.3)  # Cor do alcance com transparência

func _draw():
	draw_circle(Vector2.ZERO, 1, color)  # Desenha um círculo unitário

func _ready():
	# Garante que a escala será proporcional ao tamanho do círculo
	self.set_scale(Vector2.ONE)
