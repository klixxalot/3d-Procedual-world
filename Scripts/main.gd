extends Node3D

@export var default_tile:PackedScene
@export var tree_tile: PackedScene
@export var cannon_tile: PackedScene
@export var crystal_tile: PackedScene

#@onready var enemy: Node3D = $Enemy

@export var map_length:int = 16
@export var map_hieght:int = 9

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_map()

func generate_map():
	for x in range(map_length):
		for y in range(map_hieght):
			var random:float = randf_range(1.0, 10.0)
			if random > 9.7:
				place_tree(Vector3(x,0,y))
			else:
				place_ground(Vector3(x,0,y))
			if random < 1.01:
				place_crystal(Vector3(x,.2,y))
			#print(str(x)+ ", " + str(y))
	place_cannon(Vector3(2,.1,2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		#enemy.duplicate(1)
	pass

func place_crystal(pos:Vector3):
	var crystal:Node3D = crystal_tile.instantiate()
	add_child(crystal)
	crystal.position = pos

func place_cannon(pos:Vector3):
	#var old_tile:Node3D
	var cannon:Node3D = cannon_tile.instantiate()
	add_child(cannon)
	cannon.position = pos

func place_tree(pos:Vector3):
	var tree:Node3D = tree_tile.instantiate()
	add_child(tree)
	tree.position = pos	
	
func place_ground(pos:Vector3):
	var ground:Node3D = default_tile.instantiate()
	add_child(ground)
	ground.position = pos
