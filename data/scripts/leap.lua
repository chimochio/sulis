function on_activate(parent, ability)
  targeter = parent:create_targeter(ability)
  targeter:set_free_select(12.0)
  targeter:set_free_select_must_be_passable(parent:size_str())
  targeter:set_shape_object_size(parent:size_str())
  targeter:activate()
end

function on_target_select(parent, ability, targets)
  pos = targets:selected_point()
  
  cb = ability:create_callback(parent)
  cb:add_targets(targets)
  cb:set_on_anim_complete_fn("move_parent")
  
  speed = 300 * game:anim_base_time()
  dist = parent:dist_to_point(pos)
  duration = dist / speed
  
  anim = parent:create_subpos_anim(duration)

  delta_x = pos.x - parent:x()
  delta_y = pos.y - parent:y()
  
  y_height = 40 - math.abs(delta_x)
  
  anim:set_position(anim:param(0.0, delta_x / duration),
    anim:param(0.0, delta_y / duration - y_height, y_height / duration))
  anim:set_completion_callback(cb)
  anim:activate()
  ability:activate(parent)
end

function attack_target(parent, ability, target)
  target = targets:first()

  if target:is_valid() then
    parent:weapon_attack(target)
  end
end

function move_parent(parent, ability, targets)
  dest = targets:selected_point()
  parent:teleport_to(dest)
end
