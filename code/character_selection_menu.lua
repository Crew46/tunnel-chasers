-- title:   Tunnel Chasers
-- author:  MacklenF
-- desc:    Character Select Menu prototype
-- script:  lua

function character_menu_init()
  default_player = {
    spr_id = 0,
    speed = 1,
    lives = 3,
    ingenuity = 3,
    charisma = 1,
    acuity = 3,
    honesty = 0,
    building = "mechung_hall"
  }

  player_choice = {
    {
      name = "BYzLi",
      skill_desc = "Charismatic",
      ingenuity = 4,
      charisma = 3
    },
    {
      name = "DirtPig",
      skill_desc = "Fast",
    },
    {
      name = "Paradox",
      skill_desc = "Thin",
      ingenuity = 4
    },
    {
      name = "Null",
      skill_desc = "Equipped",
      ingenuity = 2
    },
    {
      name = "Plant",
      skill_desc = "Plant",
    },
    index = 1
  }

  select_button = string_to_button("z")
  cancel_button = string_to_button("x")

  char_menu_width = 160 -- for display ref.
  char_menu_mode = "display"

  function show_info()
    i = player_choice.index
    print("Name: " .. player_choice[i].name, 116, 106, 12)
    print("Skill: " .. player_choice[i].skill_desc, 116, 120, 12)
  end

  function initialize_player()
    player = default_player
    local index = player_choice.index
    local selection = player_choice[index]
    local ingenuity = selection.ingenuity
    local charisma = selection.charisma
    local acuity = selection.acuity
    player.spr_id = index
    if ingenuity then
      player.ingenuity = ingenuity
    end
    if charisma then
      player.charisma = charisma
    end
    if acuity then
      player.acuity = acuity
    end
  end

  function create_new_game()
    initialize_player()
    game_state={}
    progression={}
  end

  function confirm_choice()
    cls()
    rect(60, 40, 120, 60, 10)
    print("Confirm choice?", 70, 44, 12)
    print("(" .. button_to_string(select_button) .. ") to confirm", 70, 60, 12, false, 1, true)
    print("(" .. button_to_string(cancel_button) .. ") to cancel", 70, 80, 12, false, 1, true)

    if btnp(select_button) then
      create_new_game()
      initialize_player()
      current_system = "interior_level"
    end
    if btnp(cancel_button) then
      char_menu_mode = "display"
    end
  end

  function back_to_main()
    cls()
    rect(60, 40, 130, 60, 3)
    print("Return to Main Menu?", 70, 44, 12)
    print("(" .. button_to_string(select_button) .. ") to confirm", 70, 60, 12, false, 1, true)
    print("(" .. button_to_string(cancel_button) .. ") to cancel", 70, 80, 12, false, 1, true)
    if btnp(select_button) then
      current_system = "main_menu"
    end
    if btnp(cancel_button) then
      char_menu_mode = "display"
    end
  end

  function character_select()
    if btnp(cancel_button) then
      char_menu_mode = "to_main"
    end
    if btnp(select_button) then
      char_menu_mode = "confirm"
    end
    if btnp(string_to_button("left")) and player_choice.index > 1 then
      player_choice.index = player_choice.index - 1
    end
    if btnp(string_to_button("right")) and player_choice.index < #player_choice then
      player_choice.index = player_choice.index + 1
    end
  end

  function draw_character_menu()
    cls()
    rect(0, 0, 240, 136, 12) -- background
    rect(110, 100, 110, 30, 13) -- info box
    print("Select Character", 30, 24, 8, false, 2)
    print("(" .. button_to_string(select_button) .. ") to select", 10, 115, 2, false, 1, true)
    print("(" .. button_to_string(cancel_button) .. ") to Main Menu", 10, 125, 2, false, 1, true)
    -- character sprites
    local optionCount = #player_choice
    for i in ipairs(player_choice) do
      local gap = 3
      local x = (char_menu_width) * i / (optionCount) + gap * i
      local y = 55
      draw("player_portrait", i, x, y, 2)
      if (player_choice.index == i) then
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
