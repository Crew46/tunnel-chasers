---
--- Created by dkienenb.
--- DateTime: 2/13/23 12:49 PM
---

function make_system_selector_menu_system(system_name, menu_title, options)
  for i, v in ipairs(options) do
    if v.system then
      local function switch()
        current_system = v.system
      end
      options[i].action = switch
    end
  end
  make_menu_system(system_name, menu_title, options)
end

function make_menu_system(system_name, menu_title, options)
  local function menu_init()
    menu_buttons = options
    menu_selection = 1;

    function menu_draw()
      cls(0)
      print_centered(menu_title, 120, 20, 5)
      print_centered("Select: Z/right\nNavigate: up/down", 50, 136/2, 15)
      local color
      for i, v in ipairs(menu_buttons) do
        valid = (not menu_buttons[menu_selection].validator) or menu_buttons[menu_selection].validator()
        if i == menu_selection then
          if valid then
            color = 4
          else
            color=3
          end
        else
          if valid then
            color = 14
          else
            color = 15
          end
        end
        print_centered(v.text, 120, 30 + (10 * i), color)
      end
    end

    function menu_logic()
      if btnp(0) then
        menu_selection = menu_selection - 1
      end
      if btnp(1) then
        menu_selection = menu_selection + 1
      end
      if menu_selection < 1 then
        menu_selection = menu_selection + #menu_buttons
      end
      if menu_selection > #menu_buttons then
        menu_selection = menu_selection - #menu_buttons
      end
      if btnp(4) or btnp(3) then
        if (not menu_buttons[menu_selection].validator) or menu_buttons[menu_selection].validator() then
          menu_buttons[menu_selection].action()
        end
      end
    end
  end

  local function menu_loop()
    menu_logic()
    menu_draw()
  end

  make_system(system_name, menu_init, menu_loop)

end

-- end menu generator