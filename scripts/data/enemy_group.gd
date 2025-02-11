extends Node2D

# Estrutura de um grupo de inimigos
class_name EnemyGroup

var enemy_scene: PackedScene
var count: int
var interval: float
var speed: float
var group_delay: float  # Tempo entre o spawn de grupos
