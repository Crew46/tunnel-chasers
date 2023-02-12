---
--- Created by dkienenb.
--- DateTime: 2/11/23 5:14 PM
--- Debug subsystem
---
function debug_init()
  debug_index = 1
  debug_entries = {}
  for name in pairs(systems) do
    table.insert(debug_entries, name)
  end

  function debug_draw()
    cls(0)
    print_centered("Debug: Select system to load", 120, 20, 5)
    local color
    for i, v in ipairs(debug_entries) do
      if i == debug_index then
        color = 4
      else
        color = nil
      end
      print_centered(v, 120, 30 + (10 * i), color)
    end
  end

  function debug_logic()
    if button_push_util(0) then
      debug_index = debug_index - 1
    end
    if button_push_util(1) then
      debug_index = debug_index + 1
    end
    if debug_index < 1 then
      debug_index = debug_index + #debug_entries
    end
    if debug_index > #debug_entries then
      debug_index = debug_index - #debug_entries
    end
    if button_push_util(4) or button_push_util(3) then
      current_system = debug_entries[debug_index]
    end
  end

end

function debug_loop()
  debug_draw()
  debug_logic()
end

make_system("debug", debug_init, debug_loop)
-- end debug
