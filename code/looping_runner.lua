-- title:  Tunnel Chasers
-- author: MacklenF
-- desc:   Looping Runner Prototype
-- script: lua

function looping_runner_init()
  local game_over = false
  local winner = false
  local t = 0
  run_floor = 52
  jump_max = 15
  slide_max = 76
  cur_dist = 6
  
  local objects = {}
  local boosts  = {}

  local run_map = {
    cell_x  = 210,
    cell_y  = 17,
    start_x = 0,
    start_y = 0,
    width   = 30,
    height  = 17,
    speed   = (1/8)
  }
  -- p table for player references
  local p = {   
    x = 130,
    y = 52,
    y_vel = 0,
    id = 264,    --using first sprite id for test 
    run_anim = 332, 
    slide_anim = 296  -- temp.-moved sprite
  }
  
  local officer = {
    x   = 200,
    y   = 52,
    id = 350
  }  

  function draw_level()
    cls()
    map(run_map.cell_x,
      run_map.cell_y,
      run_map.width,
      run_map.height,
      run_map.start_x,
      run_map.start_y) 
    -- draw chars
    spr(p.id+(t%30//10*2),p.x,p.y, 0, 2, 1, 0, 2, 2)
    spr(officer.id+(t%30//10*32),
        officer.x, 
        officer.y, 0, 2, 0, 0, 2, 2)
  end

  function run_level_movement()
    if btnp(0) and (grounded) then
      p.y_vel = -1
      p.id = 264
      mid_jump = true
    end
    if btnp(1) and (grounded) then
      p.y_vel = 1
      p.id = p.slide_anim
      mid_slide = true
    end
  end
  
  function runner_HUD()
    rect(0, 124, 240, 12, 14)
    rectb(0, 124, 240, 12, 12)
    print("Current Distance: "..cur_dist, 4, 127, 12, false, 1, true)
    print("Timer: "..(t//60), 200, 127, 12, false, 1, true)
  end
  
  function set_timer(n)
    if (t/60) % n == 0 then -- every n seconds
      return true
    end
  end
  
  function border_check()
    if p.y == run_floor then 
      grounded = true 
    elseif p.y ~= run_floor then
      grounded = false  
    end
    if p.y < jump_max then
      p.y_vel = -p.y_vel
    end
    if p.y > slide_max then
      p.y_vel = -p.y_vel
    end
    if p.y > run_floor and (mid_jump) then
      p.y = run_floor
      p.y_vel = 0
      mid_jump = false
    end
    if p.y < run_floor and (mid_slide) then
      p.y = run_floor
      p.y_vel = 0
      mid_slide = false
      p.id = 264
    end
  end
  
  function generate_objects()
    if (need_object) then
  	  objects[#objects+1] = 
      { id = math.random(147,155),
        xp  = 0,
        yp  = math.random(40,80),
        active = true
      }
    end
    need_object = false
    if (need_boost) then
      boosts[#boosts+1] = 
      { id = math.random(246,249),
        xp  = 0,
        yp  = math.random(40,80),
        active = true
      }
    end
    need_boost = false
  end

  function draw_object()
    local obs = objects
    for i = 1,#obs do
      if obs[i] ~= nil then
        spr(obs[i].id, obs[i].xp, 
            obs[i].yp, 0, 2, 0, 0, 2, 2)
      end                  
    end
    for i = 1,#boosts do
      if boosts[i] ~= nil then
        spr(boosts[i].id, boosts[i]. xp,
            boosts[i].yp, 0, 2)
      end
    end
  end

  function move_objects()
    local obs = objects
    for i = 1,#obs do
      if obs[i] ~= nil then
        obs[i].xp = obs[i].xp + 1
        if obs[i].xp > p.x+7 then 
          obs[i].active = false
        end
        if obs[i].xp > 240 then
          table.remove(obs, i)
        end
      end
    end
    for i = 1,#boosts do
      if boosts[i] ~= nil then
        boosts[i].xp = boosts[i].xp + 1/2
        if boosts[i].xp > p.x+7 then 
          boosts[i].active = false
        end
        if boosts[i].xp > 240 then
          table.remove(boosts, i)
        end
      end
    end
  end

  function collision()
    local obs = objects
    for i = 1,#obs do
      if obs[i] ~= nil then
        if obs[i].active and
          (in_range(obs[i].xp, obs[i].yp)) then
            
            show_setback = true
            cur_dist = cur_dist - 1
            obs[i].active = false
        end
      end
    end
    for i = 1,#boosts do
      if boosts[i] ~= nil then
        if boosts[i].active and
          (in_range(boosts[i].xp, boosts[i].yp)) then
            
            show_boost = true
            cur_dist = cur_dist + 1
            boosts[i].active = false
            table.remove(boosts, i)
        end
      end
    end
  end

  function in_range(ob_x, ob_y)
    if p.x  <= ob_x + 15 then
       if p.y + 7  >= ob_y      and
          p.y + 7  <= ob_y + 23  or
          p.y + 15 >= ob_y      and
          p.y + 15 <= ob_y + 23  or
          p.y + 23 >= ob_y      and
          p.y + 23 <= ob_y + 23  then
         
         return true
      end
    end
  end
  
  function end_display()
    cls(12)
    if (game_over) then
      officer_result = "ran_away_fail"
      current_system = "continue_menu"
    end
    if (winner) then
      officer_result = "ran_away_success"
      current_system = "continue_menu"
    end 
  end

  function update()
    t = t + 1
    if set_timer(5) then
      need_object = true
    end
    if set_timer(10) then
      need_boost = true    
    end
    if (show_setback) then
      p.x = p.x + 1
      print("-1", 120, 127, 2)
      if set_timer(2) then
        show_setback = false
      end
    end
    if (show_boost) then
      p.x = p.x - 1
      print("+1", 120, 127, 5)
      if set_timer(2) then
        show_boost = false
      end
    end     
    -- boundary check for player x pos
    if p.x > 130 or p.x < 130 then
      if p.x > 135 then
        p.x = 130 
      elseif set_timer(1) then
        p.x = 130  -- reset x position
      end
    end
    -- win/lose conditions
    if (cur_dist == 0) then
      game_over = true
    end
    if set_timer(90) then
      winner = true
    end
    -- update player y pos  
    p.y = p.y + p.y_vel
    -- "scroll" map
    run_map.cell_x = run_map.cell_x - run_map.speed
  end
 
  function looping_runner_logic()
    if (not game_over) then
      draw_level()
      runner_HUD()
      run_level_movement()
      generate_objects()
      draw_object()
      move_objects()
      border_check()
      update()
      collision()
    end
    if (game_over) or (winner) then
      end_display()
    end
  end
end -- end looping_runner init


function looping_runner_loop()
  looping_runner_logic()
end

make_system("looping_runner", looping_runner_init, looping_runner_loop)

--end looping_runner
