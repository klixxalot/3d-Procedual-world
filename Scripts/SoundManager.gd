extends Node

class_name sound_manager

@onready var missile_launch: AudioStreamPlayer3D = $MissileLaunch
@onready var explosion: AudioStreamPlayer = $Explosion
@onready var gunfire: AudioStreamPlayer3D = $Gunfire


func _on_missile_spawn_point_missile_spawned(body: RigidBody3D) -> void:
	missile_launch.play(1)

func _on_enemy_enemy_destoryed(body: RigidBody3D) -> void:
	print("enemy destoryed")
	#explosion.play(0)

func _on_missile_spawn_point_2_bullet_spawned(body: RigidBody3D) -> void:
	gunfire.play()
