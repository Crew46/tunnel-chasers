-- title:   Tunnel Chasers
-- author:  MacklenF
-- desc:    Character Select Menu prototype
-- script:  lua

function character_menu_init()

  char_menu_width = 160 -- for display ref.
  char_menu_mode = "display"

  function show_info()
    i = player.selected_char.index
    print("Name: ".. player.selected_char[i].name, 116, 106, 12)
    print("Skill: ".. player.selected_char[i].skill_description, 116, 120, 12)
  end 

  function confirm_choice()
    cls()
    rect(60, 40, 120, 60, 10)
    print("Confirm choice?", 70, 44, 12)
    print("(" .. button_to_string(4) .. ") to confirm", 70, 60, 12, false, 1, true)
    print("(" .. button_to_string(5) .. ") to cancel", 70, 80, 12, false, 1, true)

    if btnp(4) then
      local index = player.selected_char.index
      local selection = player.selected_char[index]
      local ingenuity = selection.ingenuity
      local charisma = selection.charisma
      local acuity = selection.acuity
      player.sprite_id = index
      if ingenuity then
        player.ingenuity = ingenuity
      end
      if charisma then
        player.charisma = charisma
      end
      if acuity then
        player.acuity = acuity
      end
      current_system = "interior_level"
    end
    if btnp(5) then
      char_menu_mode = "display"
    end
  end

  function back_to_main()
    cls()
    rect(60, 40, 130, 60, 3)
    print("Return to Main Menu?", 70, 44, 12)
    print("(" .. button_to_string(4) .. ") to confirm", 70, 60, 12, false, 1, true)
    print("(" .. button_to_string(5) .. ") to cancel", 70, 80, 12, false, 1, true)
    if btnp(4) then
      current_system = "main_menu"
    end
    if btnp(5) then
      char_menu_mode = "display"
    end
  end

  function character_select()
    if btnp(5) then
	    char_menu_mode = "to_main"
	  end
    if btnp(4) then
      char_menu_mode = "confirm"
    end
    if btnp(2) and player.selected_char.index > 1 then
      player.selected_char.index = player.selected_char.index - 1
    end
    if btnp(3) and player.selected_char.index < #player.selected_char then
      player.selected_char.index = player.selected_char.index + 1
    end
  end

  function draw_character_menu()
    cls()
    rect(0, 0, 240, 136, 12) -- background
    rect(110, 100, 110, 30, 13) -- info box
    print("Select Character", 30, 24, 8, false, 2)
    print("(" .. button_to_string(4) .. ") to select", 10, 115, 2, false, 1, true)
    print("(" .. button_to_string(5) .. ") to Main Menu", 10, 125, 2, false, 1, true)
    -- character sprites
    local optionCount = #player.selected_char
    for i in ipairs(player.selected_char) do
      local gap = 3
      local x = (char_menu_width)*i/(optionCount) + gap * i
      local y = 55
      draw("player_portrait", i, x, y, 2)
      if (player.selected_char.index == i) then
        draw("player_portrait_box", nil, x, y)
      end
    end
  end

  function character_menu_logic()
    if (char_menu_mode == "display") then
      draw_character_menu()
      character_select()
      show_info()
    elseif (char_menu_mode == "confirm") then
      confirm_choice()
    elseif (char_menu_mode == "to_main") then
      back_to_main()
    end
  end
end

function character_menu_loop()
  character_menu_logic()
end

make_system("character_selection_menu", character_menu_init, character_menu_loop)

--end character_menu
