extends Area2D

@export_category("Data")
@export var tower_data: TowerData

@export_category("References")
@export var timer: Timer
@export var sprite_node: Sprite2D
@export var animated_sprite: AnimatedSprite2D

@export_category("Instantiates")
@export var projectile_scene: PackedScene  # Cena do projétil

var enemies_in_range: Array = []

func _ready():
	if not tower_data:
		push_error("TowerData não configurado!")
		return

	setup_tower()
	timer.wait_time = tower_data.attack_interval
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func setup_tower():
	# Configura sprite e animações com base no TowerData
	if tower_data.sprite_frames:
		animated_sprite.sprite_frames = tower_data.sprite_frames
		animated_sprite.play(tower_data.idle_animation)

func _on_timer_timeout():
	# Verifica se há inimigos no alcance
	if enemies_in_range.is_empty():
		return

	# Ordena inimigos por progressão no caminho
	enemies_in_range.sort_custom(func(a, b): return a.path_follow.get_progress() > b.path_follow.get_progress())
	var targets = enemies_in_range.slice(0, tower_data.max_targets)  # Seleciona os primeiros alvos

	# Dispara projéteis
	for target in targets:
		shoot_projectile(target)

func shoot_projectile(target):
	if not projectile_scene:
		push_error("Erro: Nenhuma cena de projétil atribuída!")
		return

	animated_sprite.play(tower_data.attack_animation)
	# Instancia e configura o projétil
	var projectile = projectile_scene.instantiate() as Node2D
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.set_target(target)  # Método customizado para passar o alvo

func _on_body_entered(body):
	if body.is_in_group("enemies") and not enemies_in_range.has(body):
		enemies_in_range.append(body)

func _on_body_exited(body):
	if body in enemies_in_range:
		enemies_in_range.erase(body)

func take_damage():
	animated_sprite.play(tower_data.take_damage_animation)

func defeat():
	animated_sprite.play(tower_data.defeat_animation)
