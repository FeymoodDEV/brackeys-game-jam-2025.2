extends Pickup
class_name Bomb

func picked_up():
	Spawning.clear_all_bullets()
	self.queue_free.call_deferred();
