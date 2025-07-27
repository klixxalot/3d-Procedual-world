extends RigidBody3D

#var target_location: Vector3
var target:RigidBody3D
@export var speed:float = .05
@export var health:float = 90

signal enemy_destoryed(body: RigidBody3D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_node("/root/Main/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#print (str(target.global_position))
	if target:
		var selfposition: Vector3 = self.global_position
		var direction = (target.global_position - selfposition).normalized()
		if selfposition.distance_to(target.global_position) > .01:
			selfposition += direction * speed * delta
			selfposition.y = max(1, selfposition.y)
			self.global_position = selfposition
			#print (str(global_position.distance_to(target.global_position)))
			#print (str(target.global_position) + " " + str(selfposition))

func _on_area_3d_body_entered(body: Node3D) -> void:
	#print("I have been entered")
	if body.is_in_group("Missile"):
		#print ("Missile - " + str(body.missile_damage))
		if body.missile_damage != 0:
			#var remaining_health: float = health - body.missile_damage
			health = health - body.missile_damage
			body.queue_free() #destroy the missile
			if(health <= 0):
				_enemy_destroyed()

func _enemy_destroyed() -> void:
	emit_signal("enemy_destoryed", self)
	queue_free()
