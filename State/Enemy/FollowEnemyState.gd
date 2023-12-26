extends EnemyState

class_name EnemyFollowState

@export var aggroCollider: Area2D
@export var navigation: NavigationAgent2D

var player: Player;

func enter():
	aggroCollider.body_exited.connect(_playerExited)
	for body in aggroCollider.get_overlapping_bodies():
		if body is Player:
			player = body

func leave():
	aggroCollider.body_exited.disconnect(_playerExited)

func physicsUpdate(_delta):
	var direction := enemy.global_position.direction_to(player.global_position)
	if abs(direction.x) > 0:
		enemy.sprite.flip_h = direction.x < 0

	#if enemy.weapon and player.global_position.distance_to(enemy.global_position) < enemy.weapon.range:
		#Transitioned.emit(self, "attack")
		#return

	navigation.target_position = player.global_position

	var currentAgentPosition: Vector2 = enemy.global_position
	var nextPathPosition: Vector2 = navigation.get_next_path_position()

	enemy.velocity = currentAgentPosition.direction_to(nextPathPosition) * enemy.speed

func _playerExited(body: Node2D):
	if body is Player:
		Transitioned.emit(self, "idle")
