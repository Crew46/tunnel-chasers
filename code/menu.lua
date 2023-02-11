---
--- Created by dkienenb.
--- DateTime: 2/10/23 5:56 PM
--- Menu system
---

function menu_init()
    local function switch_credits()
        current_system = "credits"
    end
    local function play_game()
        current_system = "charselect"
    end
    local function quit()
        exit()
    end
    menu_buttons = {
        {
            text = "PLAY",
            action = play_game
        },
        {
            text = "CREDITS",
            action = switch_credits
        },
        {
            text = "QUIT",
            action = quit
        }
    }
    menu_selection = 1;
end

function menu_draw()
    cls(0)
    print_centered("Epic menu screen!!! (Z to select)", 120, 20, 5)
    local color
    for i, v in ipairs(menu_buttons) do
        if i == menu_selection then
            color = 4
        else
            color = nil
        end
        print_centered(v.text, 120, 30 + (10 * i), color)
    end
end

function menu_logic()
    if button_push_util(0) then
        menu_selection = menu_selection - 1
    end
    if button_push_util(1) then
        menu_selection = menu_selection + 1
    end
    if menu_selection < 1 then
        menu_selection = menu_selection + #menu_buttons
    end
    if menu_selection > #menu_buttons then
        menu_selection = menu_selection - #menu_buttons
    end
    if button_push_util(4) then
        menu_buttons[menu_selection].action()
    end
end

function menu_tick()
    menu_logic()
    menu_draw()
end

make_system("menu", menu_init, menu_tick)

-- end menu
