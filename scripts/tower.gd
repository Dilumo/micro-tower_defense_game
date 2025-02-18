extends Area2D

@export_category("Data")
@export var tower_data: TowerData

@export_category("References")
@export var timer: Timer
@export var sprite_node: Sprite2D
@export var animated_sprite: AnimatedSprite2D
@export var collision_shape: CollisionShape2D
@export var range_node: Node2D  # Nó que desenha a área de alcance

@export_category("UI")
@export var confirmation_ui: Control  # Nó para o menu de confirmação
@export var name_label: Label # Exibe o nome
@export var damage_label: Label  # Exibe o dano
@export var health_label: Label  # Exibe a vida

@export_category("Instantiates")
@export var projectile_scene: PackedScene  # Cena do projétil

var enemies_in_range: Array = []
var is_confirmed: bool = false  # Indica se a torre foi confirmada

func _ready():
	if not tower_data:
		push_error("TowerData não configurado!")
		return

	# Configurar torre para o estado de pré-visualização
	setup_tower_preview()

func setup_tower_preview():
		# Configurar alcance de detecção
	if collision_shape:
		var shape = collision_shape.shape as CircleShape2D
		shape.radius = tower_data.range
	
	# Reduz opacidade e para a animação
	animated_sprite.modulate = Color(1, 1, 1, 0.5)
	animated_sprite.stop()
	
	# Mostrar área de alcance
	if range_node:
		range_node.scale = Vector2(tower_data.range, tower_data.range)

	# Mostrar UI de confirmação
	if confirmation_ui:
		confirmation_ui.visible = true
		name_label.text = tower_data.name
		damage_label.text = "Dano: %d" % tower_data.damage
		health_label.text = "Vida: %d" % tower_data.health

func confirm_tower():
	is_confirmed = true
	# Remove opacidade reduzida e inicia funcionalidade
	animated_sprite.modulate = Color(1, 1, 1, 1)
	animated_sprite.play(tower_data.idle_animation)
	if confirmation_ui:
		confirmation_ui.visible = false
		range_node.visible = false
	start_tower()

func cancel_tower():
	queue_free()  # Remove a torre

func start_tower():
	timer.wait_time = tower_data.attack_interval
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func setup_tower():
	if sprite_node:
		sprite_node.texture = tower_data.sprite
	# Configura sprite e animações com base no TowerData
	if tower_data.sprite_frames:
		animated_sprite.sprite_frames = tower_data.sprite_frames
		animated_sprite.play(tower_data.idle_animation)

func _on_timer_timeout():
	if not is_confirmed:
		return  # Não ataca enquanto não for confirmada

	if enemies_in_range.is_empty():
		return

	# Ordena inimigos por progressão no caminho
	enemies_in_range.sort_custom(func(a, b): return a.path_follow.get_progress() > b.path_follow.get_progress())
	var targets = enemies_in_range.slice(0, tower_data.max_targets)

	# Dispara projéteis
	for target in targets:
		shoot_projectile(target)

func shoot_projectile(target):
	if not projectile_scene:
		push_error("Erro: Nenhuma cena de projétil atribuída!")
		return

	animated_sprite.play(tower_data.attack_animation)
	var projectile = projectile_scene.instantiate() as Node2D
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.set_target(target)

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
