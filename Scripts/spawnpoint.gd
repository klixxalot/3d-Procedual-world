extends Node3D
class_name EnemySpawnPoint

#Enemies to spawn
@export var enemy_scenes: Array[PackedScene]

#set enemy lifesapan, max alive at one time, and delay in between spawning
@export_range(1.0, 300.00) var min_spawn_delay := 1.0
@export_range(1.0, 300.00) var max_spawn_delay := 3.0
@export var max_alive := 8  					#0, is infinate number of enemies
@export_range(0.0, 600.0) var lifetime := 0 	# 0, lives forever

# varaibles contained for THIS spawner
var _alive := 0
var _timer: SceneTreeTimer

#create a signal for the spawned enemies
signal enemy_spawned(body: RigidBody3D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enemy_scenes.is_empty():
		push_error("EnemySpawnPoint %s has no enemy scenes assigned" % name)
		return
	_schedule_next()

func _schedule_next() -> void:
	var delay := randf_range(min_spawn_delay, max_spawn_delay)
	_timer = get_tree().create_timer(delay)
	_timer.timeout.connect(_spawn)

func _spawn() -> void:
	if max_alive > 0 and _alive >= max_alive:
		#print ("skipping")
		_schedule_next()            # skipped this cycle; try again later
		return
	#pick a random enemy scene, instantiate it localy at the current 3d node transform
	var scene = enemy_scenes.pick_random()
	var enemy = scene.instantiate()
	enemy.global_transform = global_transform
	get_tree().current_scene.add_child(enemy)
	
	# keep track of current enemies spawned
	_alive += 1
	enemy_spawned.emit(enemy)
	#print("Created - " + str(_alive))

	#optional auto remove for
	if lifetime > 0.0:
		get_tree().create_timer(lifetime).timeout.connect(
			func ():
				if is_instance_valid(enemy):
					enemy.queue_free()
					#_on_enemy_destroyed()
		)
		
	enemy.tree_exited.connect(_on_enemy_destroyed, CONNECT_DEFERRED)
	_schedule_next()

func _on_enemy_destroyed() -> void:
	#_alive = max(0, _alive, -1)
	_alive -= 1
	_alive = max(0, _alive)
	#print ("Deleted - " +str(_alive))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
