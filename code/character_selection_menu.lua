-- title:   Tunnel Chasers
-- author:  MacklenF
-- desc:    Character Select Menu prototype
-- script:  lua

function character_menu_init()

  pc={x=240/2,y=136/2,spr_id=0,
    spr_Id_h=256,spr_Id_b=264,CLRK=0,scale=1,flip=0,
    changeFrame=false,CF=1,CF_timer=30,
    isIdle=true,isRun=false,isTurned=false,
    isCrouch=false,isHidden=false,
    indx=1,selected="pig",state="Idle",speed=1,
    lives=3,ingenuity=3,charisma=1,acuity=5,honesty=0,
    building = "mechung_hall",
    nameTbl={"pig","nul","par","byz","pla"},
      sprTbl={256,288,320,352,384},
      spdTbl={0.8,0.65,0.75,0.7,1},
    sprites={}
  }

  for n=1,5 do
    local spr_id=pc.sprTbl[n]
    pc.sprites[n]={}
    for c=1,16 do
      pc.sprites[n][c]=spr_id
      spr_id=spr_id+2
      if (n==5) and (c==5) then break end
    end
  end

  player_choice = {
    {
      name="DirtPig",
      skill_desc="Fast",
    },
    {
      name="Null",
      skill_desc="Equipped",
      ingenuity=2
    },
    {
      name="Paradox",
      skill_desc="Thin",
      ingenuity=4
    },
    {
      name="BYzLi",
      skill_desc="Charismatic",
      ingenuity=4,
      charisma=3
    },
    {
      name="Plant",
      skill_desc="Plant",
    },
    index=1
  }

  select_button=string_to_button("z")
  cancel_button=string_to_button("x")

  char_menu_width=160 -- for display ref.
  char_menu_mode="display"

  function show_info()
    i=player_choice.index
    print("Name: " .. player_choice[i].name,116,106,12)
    print("Skill: " .. player_choice[i].skill_desc,116,120,12)
  end

  function initialize_player()
    player=pc
    local index=player_choice.index
    local selection=player_choice[index]
    local ingenuity=selection.ingenuity
    local charisma=selection.charisma
    local acuity=selection.acuity
    player.spr_id=index
    if ingenuity then
      player.ingenuity=ingenuity
    end
    if charisma then
      player.charisma=charisma
    end
    if acuity then
      player.acuity=acuity
    end
    pc.indx=index
    pc.selected=pc.nameTbl[pc.indx]
    pc.spr_Id_h=pc.sprTbl[pc.indx]
    pc.spr_Id_b=pc.spr_Id_h+8
    pc.speed=pc.spdTbl[pc.indx]
  end

  function create_new_game()
    initialize_player()
    game_state={}
    progression={}
  end

  function confirm_choice()
    cls()
    rect(60,40,120,60,10)
    print("Confirm choice?",70,44,12)
    print("(" .. button_to_string(select_button) .. ") to confirm",70,60,12,false,1,true)
    print("(" .. button_to_string(cancel_button) .. ") to cancel",70,80,12,false,1,true)

    if btnp(select_button) then
      create_new_game()
      current_system="interior_level"
    end
    if btnp(cancel_button) then
      char_menu_mode="display"
    end
  end

  function back_to_main()
    cls()
    rect(60,40,130,60,3)
    print("Return to Main Menu?",70,44,12)
    print("(" .. button_to_string(select_button) .. ") to confirm",70,60,12,false,1,true)
    print("(" .. button_to_string(cancel_button) .. ") to cancel",70,80,12,false,1,true)
    if btnp(select_button) then
      current_system="main_menu"
    end
    if btnp(cancel_button) then
      char_menu_mode="display"
    end
  end

  function character_select()
    if btnp(cancel_button) then
      char_menu_mode="to_main"
    end
    if btnp(select_button) then
      char_menu_mode="confirm"
    end
    if btnp(string_to_button("left")) and (player_choice.index>1) then
      player_choice.index=player_choice.index-1
    end
    if btnp(string_to_button("right")) and (player_choice.index<#player_choice) then
      player_choice.index=player_choice.index+1
    end
  end

  function draw_character_menu()
    cls()
    rect(0,0,240,136,12) -- background
    rect(110,100,110,30,13) -- info box
    print("Select Character",30,24,8,false,2)
    print("(" .. button_to_string(select_button) .. ") to select",10,115,2,false,1,true)
    print("(" .. button_to_string(cancel_button) .. ") to Main Menu",10,125,2,false,1,true)
    -- character sprites
    local optionCount=#player_choice
    for i in ipairs(player_choice) do
      local gap=3
      local x=(char_menu_width)*i/(optionCount)+gap*i
      local y=55
      draw("player_portrait",i,x,y,2)
      if (player_choice.index==i) then
        draw("player_portrait_box",nil,x,y)
      end
    end
  end

  function character_menu_logic()
    if (char_menu_mode=="display") then
      draw_character_menu()
      character_select()
      show_info()
    elseif (char_menu_mode=="confirm") then
      confirm_choice()
    elseif (char_menu_mode=="to_main") then
      back_to_main()
    end
  end
end

function character_menu_loop()  
  character_menu_logic()
  print("Head: "..pc.spr_Id_h,0,6,6)
  print("Body: "..pc.spr_Id_b,60,6,6)
	print("Selected char: "..pc.selected,0,12,6)
end

make_system("character_selection_menu",character_menu_init,character_menu_loop)

--end character_menu
