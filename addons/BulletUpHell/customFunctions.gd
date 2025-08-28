extends Node
class_name customFunctions

###
## here, you can write custom logic to attach to BuHSpawner.gd
## just create a function, and call then call it from BuHSpawner.gd using CUSTOM.<yourfunction>
## it is better than writing custom logic in BuHSpawner.gd
## because your code would be overwritten at each plugin update
###

var particles: Array[GPUParticles2D];

func back_to_grave_deferred(bID):
	var par = bID.get_parent();
	if par and bID:
		par.remove_child(bID)
	else:
		print(par)
		
func delete_bullet_outside(bullet):
	if bullet["position"].x < -250 or bullet["position"].x > 2000:
		Spawning.delete_bullet(bullet);
	if bullet["position"].y < -250 or bullet["position"].y > 2000:
		Spawning.delete_bullet(bullet);

func _on_hit_particle_finished(particle):
	if particle in get_children():
		particle.emitting = false;
		remove_child(particle);
		particles.append(particle)

func bullet_collide_body(body_rid:RID,body:Node,body_shape_index:int,local_shape_index:int,shared_area:Area2D, B:Dictionary, b:RID) -> void:
	## you can use B["props"]["damage"] to get the bullet's damage
	## you can use B["props"]["<your custom data name>"] to get the bullet's custom data
	
	var damage = B["props"]["damage"];
	var knockback = B["props"]["knockback"];
	
	# If we hit any of the damageables!
	if body is Block or body is EnemyController or PlayerController:
		if body is not Block:
			body.apply_damage(damage, knockback, B["position"], -body.velocity);
		else:
			body.apply_damage(damage, knockback, B["position"], Vector2.ZERO);
		print(B);
		B["props"]["remaining_pierce"] -= 1;
		if B["props"]["remaining_pierce"] <= 0:
			var hit_vfx;
			if particles.size() < 500:
				hit_vfx = B["props"]["hit_vfx"].duplicate();
				hit_vfx.finished.connect(_on_hit_particle_finished.bind(hit_vfx))
				body.get_parent().add_child(hit_vfx);
			else:
				hit_vfx = particles.pop_front();
			
			if hit_vfx:
				hit_vfx.show();
				hit_vfx.global_position = (B["position"] as Vector2);
				hit_vfx.emitting = true
			Spawning.delete_bullet(b);


	pass


func bullet_collide_area(area_rid:RID,area:Area2D,area_shape_index:int,local_shape_index:int,shared_area:Area2D) -> void:
	## you can use B["props"]["damage"] to get the bullet's damage
	## you can use B["props"]["<your custom data name>"] to get the bullet's custom data
	
	############## uncomment if you want to use the standard behavior below ##############
	var rid = Spawning.shape_rids.get(shared_area.name, {}).get(local_shape_index)
	if not Spawning.poolBullets.has(rid): return
	var B = Spawning.poolBullets[rid]
	
	############## emit signal
	Spawning.bullet_collided_area.emit(area,area_shape_index,B,local_shape_index,shared_area)
	
	############## uncomment to manage trigger collisions with area collisions
#	if B["trig_types"].has("TrigCol"):
#		B["trig_collider"] = area
#		B["trig_container"].checkTriggers(B, rid)
	pass
