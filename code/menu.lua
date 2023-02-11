---
--- Created by dkienenb.
--- DateTime: 2/10/23 5:56 PM
--- Menu system
---

function menu_init()
    menu_buttons = {}
end

function menu_tick()
    cls(0)
    print_centered("Epic menu screen", 120, 20)
    secondary()
end

make_system("menu", menu_init, menu_tick)

-- end menu
