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
        skill_description = "Hide behind thin objects"
      },
      {
        name = "Null",
        skill_description = "Carries a lockpick"
      },
      {
        name = "Plant",
        skill_description = "Invisible when not moving"
      }
    }
  }

  char_menu_width = 160 -- for display ref.
  char_menu_mode = "display"

  box_select = { -- box for "highlighting" player
    x = 96,
    y = 60,
    width = 24,
    height = 24,
    color = 11,
    pos = {
      [1] = char_menu_width*1/5,
      [2] = char_menu_width*2/5,
      [3] = char_menu_width*3/5,
      [4] = char_menu_width*4/5,
      [5] = char_menu_width
    }
  }

  function highlight()
    rectb(box_select.x,
      box_select.y,
      box_select.width,
      box_select.height,
      box_select.color)

    if btnp(2) then
      box_select.x = box_select.x-32
      if (box_select.x < 32) then
        box_select.x = 32
      end
    end
    if btnp(3) then
      box_select.x = box_select.x+32
      if (box_select.x > 160) then
        box_select.x = 160
      end
    end
  end

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
    print("(" .. button_to_string(2) .. ") to cancel", 70, 80, 12, false, 1, true)
    if btnp(0) then
      current_system = "main_menu"
    end
    if btnp(2) then
      char_menu_mode = "display"
    end
  end

  function character_select()
    if btnp(1) then
	    char_menu_mode = "to_main"
	  end
    if (box_select.x == box_select.pos[1]) then
      player.char_option.index = 1
      show_info()
      if btnp(0) then
        char_menu_mode = "confirm"
      end
    end
    if (box_select.x == box_select.pos[2]) then
      player.char_option.index = 2
      show_info()
      if btnp(0) then
        char_menu_mode = "confirm"
      end
    end
    if (box_select.x == box_select.pos[3]) then
      player.char_option.index = 3
      show_info()
      if btnp(0) then
        char_menu_mode = "confirm"
      end
    end
    if (box_select.x == box_select.pos[4]) then
      player.char_option.index = 4
      show_info()
      if btnp(0) then
        char_menu_mode = "confirm"
      end
    end
    if (box_select.x == box_select.pos[5]) then
      player.char_option.index = 4
      show_info()
      if btnp(0) then
        char_menu_mode = "confirm"
      end
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
    spr(0, char_menu_width*1/5, 60, -1, 3)
    spr(1, char_menu_width*2/5, 60, -1, 3)
    spr(2, char_menu_width*3/5, 60, -1, 3)
    spr(3, char_menu_width*4/5, 60, -1, 3)
    spr(4, char_menu_width, 60, -1, 3)
  end

  function character_menu_logic()
    if (char_menu_mode == "display") then
      draw_character_menu()
      highlight()
      character_select()
    end
    if (char_menu_mode == "confirm") then
      confirm_choice()
    end
    if (char_menu_mode == "to_main") then
      back_to_main()
    end
  end
end

function character_menu_loop()
  character_menu_logic()
end

make_system("character_selection_menu", character_menu_init, character_menu_loop)

--end character_menu
