-- title:   Tunnel Chasers
-- author:  MacklenF
-- desc:    Character Select Menu prototype
-- script:  lua

function character_menu_init()
  player = {
    sprite = 0,
    speed  = 1,
    lives  = 3,
    building = "machung_hall",
    progression = {},
    char_option = {
      {
        name = "Bear",
        skill_description = "Charismatic" 
      },
      {
        name = "Dirtpig",
        skill_description = "Fast"
      },
      {
        name = "Paradox",
        skill_description = "Thin"
      },
      {
        name = "Null",
        skill_description = "Equipped"
      },
      {
        name = "Plant",
        skill_description = "Plant"
      },
      index=1
    }
  }

  char_menu_width = 160 -- for display ref.
  char_menu_mode = "display"

  function show_info()
    i = player.char_option.index
    print("Name: ".. player.char_option[i].name, 116, 106, 12)
    print("Skill: ".. player.char_option[i].skill_description, 116, 120, 12)
  end 

  function confirm_choice()
    cls()
    rect(60, 40, 120, 60, 10)
    print("Confirm choice?", 70, 44, 12)
    print("(" .. button_to_string(0) .. ") to confirm", 70, 60, 12, false, 1, true)
    print("(" .. button_to_string(1) .. ") to cancel", 70, 80, 12, false, 1, true)

    if btnp(0) then
      player.sprite = player.char_option.index
      current_system = "interior_level"
    end
    if btnp(1) then
      char_menu_mode = "display"
    end
  end

  function back_to_main()
    cls()
    rect(60, 40, 130, 60, 3)
    print("Return to Main Menu?", 70, 44, 12)
    print("(" .. button_to_string(0) .. ") to confirm", 70, 60, 12, false, 1, true)
    print("(" .. button_to_string(1) .. ") to cancel", 70, 80, 12, false, 1, true)
    if btnp(0) then
      current_system = "main_menu"
    end
    if btnp(1) then
      char_menu_mode = "display"
    end
  end

  function character_select()
    if btnp(1) then
	    char_menu_mode = "to_main"
	  end
    if btnp(0) then
      char_menu_mode = "confirm"
    end
    if btnp(2) and player.char_option.index > 1 then
      player.char_option.index = player.char_option.index - 1
    end
    if btnp(3) and player.char_option.index < #player.char_option then
      player.char_option.index = player.char_option.index + 1
    end
  end

  function draw_character_menu()
    cls()
    rect(0, 0, 240, 136, 12) -- background
    rect(110, 100, 110, 30, 13) -- info box
    print("Select Character", 30, 24, 8, false, 2)
    print("(" .. button_to_string(0) .. ") to select", 10, 115, 2, false, 1, true)
    print("(" .. button_to_string(1) .. ") to Main Menu", 10, 125, 2, false, 1, true)
    -- character sprites
    local optionCount = #player.char_option
    for i in ipairs(player.char_option) do
      local gap = 3
      local x = (char_menu_width)*i/(optionCount) + gap * i
      local y = 55
      draw("player_portrait", i, x, y, 2)
      if (player.char_option.index == i) then
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
