---
--- Created by dkienenb.
--- DateTime: 2/11/23 5:14 PM
--- Debug subsystem
---
function debug_init()
  debug_entries = {}
  for name in pairs(systems) do
    table.insert(debug_entries, {text=name,system=name})
  end
end

debug_init()

make_system_selector_menu_system("debug", "Debug: Select system to load", debug_entries)
-- end debug
