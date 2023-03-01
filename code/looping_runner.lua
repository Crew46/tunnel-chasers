-- title:  Tunnel Chasers
-- author: MacklenF
-- desc:   Looping Runner Prototype
-- script: lua

function looping_runner_init()
  local game_over = false
  local winner = false
  local t = 0
  run_floor = 112
  jump_max = 90
  cur_dist = 6

  local objects = {}
  local boosts  = {}

  local run_map = {
    cell_x  = 0,
    cell_y  = 34,
    start_x = 0,
    start_y = 0,
    width   = 30,
    height  = 17,
    speed   = (1/16)
  }
  -- p table for player references
  local p = {   
    x = 46,
    y = 112,
    x_vel = (1/16),
    y_vel = 0,
    id = 264,        -- using first sprite id for test
    h = 2,           -- toggle height for slide anim 
    run_anim = 332, 
    slide_anim = 312 -- temp.-moved sprite
  }
  
  local officer = {
    x   = 4,
    y   = 112,
    x_vel = (1/16),
    y_vel = 0,
    id = 456 
  }  

  function draw_level()
    cls()
    map(run_map.cell_x/2,
      run_map.cell_y/2,
      run_map.width,
      run_map.height,
      run_map.start_x,
      run_map.start_y)
    -- draw chars
    spr(p.id+t%60//30*68,p.x,p.y, 0, 1, 0, 0, 2, p.h)
    spr(officer.id+t%60//30*2,
        officer.x, 
        officer.y, 0, 1, 0, 0, 2, 2)
    -- display info
    print("Escape the officer!!", 4, 20, 2) 
    print("(up) to jump", 4, 40, 5, false, 1, true)  
    print("(down) to slide", 4, 50, 5, false, 1, true)
    print("Collect the boosts ->", 140, 20, 5, false, 1, true)
    print("Avoid the objects ->", 140, 30, 5, false, 1, true)
    spr(246+t%60//30, 225, 20, 0)
    spr(241+t%60//30, 225, 30, 0)
  end

  function runner_HUD()
    rect(0, 0, 240, 16, 10)
    rectb(0, 0, 240, 16, 12)
    print("Current Distance: "..cur_dist, 4, 4, 12, false, 1, true)
    print("Timer: "..(t//60), 200, 4, 12, false, 1, true)
  end
  
  function set_timer(n)
    if (t/60) % n == 0 then -- every n seconds
      return true
    end
  end
  
  function run_level_movement()
    if btn(0) then  -- jump
      slide = false
      p.h = 2
      p.id = 264
      p.y_vel = -1/2
    elseif btn(1)  then -- slide
      slide = true      
      p.y_vel = 0
      p.h = 1
      p.id = p.slide_anim
    end
    if btn(3) then  -- reset to running
      slide = false
      p.h = 2
      p.id = 264
      p.y_vel = 0
    end
  end
  
  function boundary()
    if p.y > run_floor and (not slide) then
      p.y = run_floor
    elseif p.y > run_floor and (slide) then
      p.y = 128    
    end
    if p.y < jump_max then
      p.y_vel = -p.y_vel
    end
  end
  
  function setback()
    p.x = p.x - 5
    cur_dist = cur_dist - 1
  end
  
  function power_up()
    p.x = p.x + 5
    cur_dist = cur_dist + 1
  end

  function generate_objects()
    if (need_object) then
      objects[#objects+1] = 
      { id = math.random(241,244),
        xp  = math.random(170,200),
        yp  = math.random(104,128),
        active = true
      }
    end
    need_object = false
    if (need_boost) then
      boosts[#boosts+1] = 
      { id = math.random(246,249),
        xp  = math.random(170,200),
        yp  = math.random(90,110),
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
            obs[i].yp, 0, 1, 0, 1+t%60//30)
      end                   -- rotate sprite
    end
    for i = 1,#boosts do
      if boosts[i] ~= nil then
        spr(boosts[i].id, boosts[i]. xp,
            boosts[i].yp, 0)
      end
    end
  end

  function move_objects()
    local obs = objects
    for i = 1,#obs do
      if obs[i] ~= nil then
        obs[i].xp = obs[i].xp - 1/2
        if obs[i].xp < p.x-4 then 
          obs[i].active = false
        end
        if obs[i].xp < 0 then
          table.remove(obs, i)
        end
      end
    end
    for i = 1,#boosts do
      if boosts[i] ~= nil then
        boosts[i].xp = boosts[i].xp - 1/4
        if boosts[i].xp < p.x-4 then 
          boosts[i].active = false
        end
        if boosts[i].xp < 0 then
          table.remove(boosts, i)
        end
      end
    end
  end

  function in_range(ob_x, ob_y)
    -- check top right
    if p.x + 15 >= ob_x  and
       p.y      >= ob_y  and
       p.y      <= ob_y+7  or
    --  middle right        
       p.x + 15 >= ob_x  and
       p.y + 7  >= ob_y  and
       p.y + 7  <= ob_y+7  or
     -- bottom right
       p.x + 15 >= ob_x  and
       p.y + 15 >= ob_y  and
       p.y + 15 <= ob_y+7  then
 
         return true
    end
  end

  function collision()
    local obs = objects
    for i = 1,#obs do
      if obs[i] ~= nil then
        if obs[i].active and
          (in_range(obs[i].xp, obs[i].yp)) then
            
            print("collision!", 100, 60, 2)
            setback()
            obs[i].active = false
        end
      end
    end
    for i = 1,#boosts do
      if boosts[i] ~= nil then
        if boosts[i].active and
          (in_range(boosts[i].xp, boosts[i].yp)) then
            
            print("BOOST!", 100, 60, 6)
            power_up()
            boosts[i].active = false
            table.remove(boosts, i)
        end
      end
    end
  end

  function update()
    t = t + 1
    if set_timer(3) then
      need_object = true
    end
    if set_timer(10) then
      need_boost = true    
    end
    -- update char positions  
    p.y = p.y + p.y_vel
    p.x = p.x + p.x_vel
    officer.x = officer.x + officer.x_vel
    -- "scroll" map
    run_map.cell_x = run_map.cell_x + run_map.speed
    if (run_map.cell_x > 60) then
      run_map.cell_x = 0
    end
    if (cur_dist == 0) then
      game_over = true
    end
    if (p.x + 15 > 240) then
      winner = true
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
 
  function looping_runner_logic()
    if (not game_over) then
      draw_level()
      run_level_movement()
      runner_HUD()
      generate_objects()
      draw_object()
      move_objects()
      boundary()
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
