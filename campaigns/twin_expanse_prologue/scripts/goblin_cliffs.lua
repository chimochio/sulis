function on_enter_ambush(parent, target)
  game:cancel_blocking_anims()
  game:spawn_encounter_at(83, 46)
  game:scroll_view(88, 55)
  game:start_conversation("goblin_cliffs_ambush", game:player())
end

function after_escape_cutscene(parent, target)
  game:load_module("twin_expanse_ch1")
end

function on_area_load(parent)
  game:set_quest_entry_state("the_goblin_trap", "cliffs", "Active")
end