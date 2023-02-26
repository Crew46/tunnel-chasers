-- title:   Tunnel Chasers
-- author:  MacklenF
-- desc:    Character Select Menu prototype
-- script:  lua

function character_menu_init()

  char_menu_width = 160 -- for display ref.
  char_menu_mode = "display"

  function show_info()
    i = pc.select_char.index
    print("Name: ".. pc.select_char[i].name, 116, 106, 12)
    print("Skill: ".. pc.select_char[i].skill_desc, 116, 120, 12)
  end 

  function confirm_choice()
    cls()
    rect(60, 40, 120, 60, 10)
    print("Confirm choice?", 70, 44, 12)
    print("(" .. button_to_string(bttn.z) .. ") to confirm", 70, 60, 12, false, 1, true)
    print("(" .. button_to_string(bttn.x) .. ") to cancel", 70, 80, 12, false, 1, true)

    if btnp(bttn.z) then
      local index = pc.select_char.index
      local selection = pc.select_char[index]
      local ingenuity = selection.ingenuity
      local charisma = selection.charisma
      local acuity = selection.acuity
      pc.spr_id = index
      if ingenuity then
        pc.ingenuity = ingenuity
      end
      if charisma then
        pc.charisma = charisma
      end
      if acuity then
        pc.acuity = acuity
      end
      current_system = "interior_level"
    end
    if btnp(bttn.x) then
      char_menu_mode = "display"
    end
  end

  function back_to_main()
    cls()
    rect(60, 40, 130, 60, 3)
    print("Return to Main Menu?", 70, 44, 12)
    print("(" .. button_to_string(bttn.z) .. ") to confirm", 70, 60, 12, false, 1, true)
    print("(" .. button_to_string(bttn.x) .. ") to cancel", 70, 80, 12, false, 1, true)
    if btnp(bttn.z) then
      current_system = "main_menu"
    end
    if btnp(bttn.x) then
      char_menu_mode = "display"
    end
  end

  function character_select()
    if btnp(bttn.x) then
	    char_menu_mode = "to_main"
	  end
    if btnp(bttn.z) then
      char_menu_mode = "confirm"
    end
    if btnp(bttn.l) and pc.select_char.index > 1 then
      pc.select_char.index = pc.select_char.index - 1
    end
    if btnp(bttn.r) and pc.select_char.index < #pc.select_char then
      pc.select_char.index = pc.select_char.index + 1
    end
  end

  function draw_character_menu()
    cls()
    rect(0, 0, 240, 136, 12) -- background
    rect(110, 100, 110, 30, 13) -- info box
    print("Select Character", 30, 24, 8, false, 2)
    print("(" .. button_to_string(bttn.z) .. ") to select", 10, 115, 2, false, 1, true)
    print("(" .. button_to_string(bttn.x) .. ") to Main Menu", 10, 125, 2, false, 1, true)
    -- character sprites
    local optionCount = #pc.select_char
    for i in ipairs(pc.select_char) do
      local gap = 3
      local x = (char_menu_width)*i/(optionCount) + gap * i
      local y = 55
      draw("player_portrait", i, x, y, 2)
      if (pc.select_char.index == i) then
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
