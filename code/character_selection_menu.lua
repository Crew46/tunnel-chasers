-- title:   Tunnel Chasers
-- author:  MacklenF
-- desc:    Character Select Menu prototype
-- script:  lua

function character_menu_init()
  player = {
    sprNum = 0,

    [0] = { 
      name = "Player Zero", 
      skill = "Skill zero" 
    },
    [1] = {
      name = "Player One",
      skill = "Skill One"
     },
    [2] = {
      name = "Player Two",
      skill = "Skill Two"
    },
    [3] = {
      name = "Player Three",
      skill = "Skill Three"
    },
    [4] = {
      name = "Player Four",
      skill = "Skill Four"
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
      [0] = char_menu_width*1/5,
      [1] = char_menu_width*2/5,
      [2] = char_menu_width*3/5,
      [3] = char_menu_width*4/5,
      [4] = char_menu_width
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
    i = player.sprNum
    print("Name: "..player[i].name, 116, 106, 12)
    print("Skill: "..player[i].skill, 116, 120, 12)
  end 

  function confirm_choice()
    cls()
    rect(60, 40, 120, 60, 10)
    print("Confirm choice?", 70, 44, 12)
    print("(UP) to confirm", 70, 60, 12)
    print("(DOWN) to cancel", 70, 80, 12)

    if btnp(0) then
    --do next game step
    end
    if btnp(1) then
      char_menu_mode = "display"
    end
  end

  function character_select()
    if (box_select.x == box_select.pos[0]) then
      player.sprNum = 0
      show_info()
      if btnp(0) then
        char_menu_mode = "confirm"
      end
    end
    if (box_select.x == box_select.pos[1]) then
      player.sprNum = 1
      show_info()
      if btnp(0) then
        char_menu_mode = "confirm"
      end
    end
    if (box_select.x == box_select.pos[2]) then
      player.sprNum = 2
      show_info()
      if btnp(0) then
        char_menu_mode = "confirm"
      end
    end
    if (box_select.x == box_select.pos[3]) then
      player.sprNum = 3
      show_info()
      if btnp(0) then
        char_menu_mode = "confirm"
      end
    end
    if (box_select.x == box_select.pos[4]) then
      player.sprNum = 4
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
    print("(UP to select)", 30, 120, 2)
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
  end
end

function character_menu_loop()
  character_menu_logic()
end

make_system("character_selection_menu", character_menu_init, character_menu_loop)

--end character_menu
