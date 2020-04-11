SONG_NAME="song_of_curses"

--INCLUDE common_song

function get_targets(parent)
  return parent:targets():hostile()
end

function set_anim_color(anim)
  anim:set_color(anim:param(1.0), anim:param(0.0), anim:param(0.0), anim:param(0.5))
  
  game:play_sfx("sfx/guitar")
  game:play_sfx("sfx/song_bad")
end

function on_entered(parent, ability, targets)
  local target = targets:first()
  
  local effect = target:create_effect(ability:name())
  effect:set_tag(SONG_NAME)
  
  if parent:is_hostile(target) then
    factor = 1 + parent:get_num_flag("bard_bonus_factor")
    
    local stats = parent:stats()
    local bonus = (10 + stats.caster_level / 2 + stats.perception_bonus / 2) * -0.015 * factor
    effect:add_num_bonus("crit_multiplier", bonus * 1.5)
    effect:add_num_bonus("hit_multiplier", bonus)
    effect:add_num_bonus("graze_multiplier", bonus * 0.75)
  end
  
  create_hear_anim(parent, target, effect)
  
  effect:apply()
end
