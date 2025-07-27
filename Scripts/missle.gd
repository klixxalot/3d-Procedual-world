extends RigidBody3D

var target:RigidBody3D 
var speed:float
var missile_damage:float
var range:float

var starting_position:Vector3

func _ready() -> void:
	#print (str(target))
	starting_position = global_position
	if target != null:
		print (str(target.global_position))
	else:
		push_error("Missile has no target!")
		return
	
func _physics_process(delta: float) -> void:
		var selfposition: Vector3 = self.global_position
		if starting_position.distance_to(selfposition) > range:
			queue_free()
		if target != null:  #if target gets killed or despawns destroy the missile
			var direction = (target.global_position - selfposition).normalized()
			if selfposition.distance_to(target.global_position) > .01:
				#Move the missile towards the tartet
				self.global_position += direction * speed * delta
				#Rotate the missile to orient to the target
				look_at(target.global_position, Vector3.UP)
		else:
			queue_free()
