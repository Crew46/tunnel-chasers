-- title:  Tunnel Chasers
-- author: MacklenF
-- desc:   Looping Runner Prototype
-- script: lua

function looping_runner_init()
  local game_over = false
  local winner = false
  local t = 0
  local count = 3600 -- 60 sec * 60 frames/sec
  run_floor = 52
  jump_max = 24
  slide_max = 76
  cur_dist = 6.0
  gravity = 0.2
    
  local objects = {}
  local boosts  = {}

  local run_map = {
    cell_x  = 210,
    cell_y  = 17,
    start_x = 0,
    start_y = 0,
    width   = 30,
    height  = 17,
    speed   = -(1/6)
  }
  -- p table for player references
  local p = {   
    x = 130,
    y = 52,
    y_vel = 0,
    id = 264,    -- using first sprite id for test 
    run_anim   = 264,
    jump_anim  = 266, 
    slide_anim = 268,  -- temp.-moved sprite
    flip = 1
  }
  
  local officer = {
    x   = 200,
    y   = 52,
    id = 350,
    flip = 1
  }  
  
  run_direction = {right = false, left = false}
  run_direction.left = true
  
  new_object_x = 0  -- defaults set to left
  obs_speed = 1.5
  bst_speed = 1/2
 
  function set_direction_vars(run_direction)
    if (run_direction.right) then
      p.x = 80
      officer.x = 10
      run_map.speed = -run_map.speed
      p.flip = 0
      officer.flip = 0
      new_object_x = 240
      obs_speed = -1.5
      bst_speed = -1/2
    end
  end
  set_direction_vars(run_direction)
   
  function draw_level()
    cls()
    map(run_map.cell_x,
      run_map.cell_y,
      run_map.width,
      run_map.height,
      run_map.start_x,
      run_map.start_y) 
    -- draw chars
    spr(p.id+(t%20//10*32), p.x, p.y, 0, 2, p.flip, 0, 2, 2)
    spr(officer.id+(t%30//10*32),
        officer.x, 
        officer.y, 0, 2, officer.flip, 0, 2, 2)
  end

  function run_level_movement()
    if btnp(0) and (grounded) then
      p.y_vel = -2.5
      p.id = p.jump_anim
      mid_jump = true      
    end
    if btnp(1) and (grounded) then
      p.y_vel = 1.5
      p.id = p.slide_anim
      mid_slide = true    
    end
  end
  
  function runner_HUD()
    rect(0, 124, 240, 12, 14)
    rectb(0, 124, 240, 12, 12)
    print("Current Distance: "..cur_dist, 4, 127, 12, false, 1, true)
    print("Time: "..math.floor((count/60)*10)/10, 200, 127, 12, false, 1, true)
  end
  
  function set_timer(n)
    if t > 0 then
      if (t/60) % n == 0 then -- every n seconds
        return true
      end
    end
  end
      
  function border_check()
    if p.y == run_floor then 
      grounded = true 
    elseif p.y ~= run_floor then
      grounded = false  
    end
    if p.y < jump_max then
      p.y_vel = p.y_vel + gravity
    end
    if p.y > slide_max then
      p.y = slide_max
      if set_timer(1) then  -- longer slide
        p.id = p.run_anim
        p.y_vel = -p.y_vel + gravity 
      end
    end
    if p.y > run_floor and (mid_jump) or
       p.y < run_floor and (mid_slide) then
         p.y = run_floor
         p.y_vel = 0
         mid_jump = false
         mid_slide = false
         p.id = p.run_anim
    end
  end
  
  function generate_objects()
    if set_timer(3) then
      need_object = true
    end
    if set_timer(8) then
      need_boost = true    
    end
    if (need_object) then
  	  objects[#objects+1] = 
      { id = math.random(147,155),
        xp  = new_object_x,
        yp  = math.random(40,80),
        active = true
      }
    end
    need_object = false
    if (need_boost) then
      boosts[#boosts+1] = 
      { id = math.random(246,249),
        xp  = new_object_x,
        yp  = math.random(40,80),
        active = true
      }
    end
    need_boost = false
  end

  function draw_objects()
    local obs = objects
    for i = 1,#obs do
      if obs[i] ~= nil then
        spr(obs[i].id, obs[i].xp, 
            obs[i].yp, 0, 2, 0, 0, 2, 2)
      end                  
    end
    for i = 1,#boosts do
      if boosts[i] ~= nil then
        spr(boosts[i].id, boosts[i].xp,
            boosts[i].yp, 0, 2)
      end
    end
  end

  function move_objects()
    local obs = objects
    for i = 1,#obs do
      if obs[i] ~= nil then
        obs[i].xp = obs[i].xp + obs_speed 
        if obs[i].xp > p.x + 32 and 
          (run_direction.left) then 
            obs[i].active = false
          if obs[i].xp > 240 then
            table.remove(obs, i)
          end
        elseif obs[i].xp + 32 < p.x and 
          (run_direction.right) then
            obs[i].active = false
          if obs[i].xp < 0 then
            table.remove(obs, i)
          end
        end
      end
    end
    for i = 1,#boosts do
      if boosts[i] ~= nil then
        boosts[i].xp = boosts[i].xp + bst_speed
        if boosts[i].xp > p.x + 32 and 
          (run_direction.left) then 
            boosts[i].active = false
            if boosts[i].xp > 240 then
              table.remove(boosts, i)            
            end
        elseif boosts[i].xp + 32 < p.x and 
          (run_direction.right) then
            boosts[i].active = false
            if boosts[i].xp < 0 then
              table.remove(boosts, i)
            end  
        end
      end
    end
  end

  function collision()
    local obs = objects
    for i = 1,#obs do
      if obs[i] ~= nil then
        if obs[i].active and
          (object_col(obs[i].xp, obs[i].yp)) then
            
            show_setback = true
            cur_dist = cur_dist - 1.0
            obs[i].active = false           
            if (show_setback) and 
              (run_direction.left) then
              p.x = p.x + 8  
              show_setback = false
            elseif (show_setback) and 
              (run_direction.right) then
              p.x = p.x - 8
              show_setback = false
            end
        end
      end
    end
    for i = 1,#boosts do
      if boosts[i] ~= nil then
        if boosts[i].active and
          (boost_col(boosts[i].xp, boosts[i].yp)) then
            
            show_boost = true
            cur_dist = cur_dist + 1.0
            boosts[i].active = false
            table.remove(boosts, i)            
            if (show_boost) and 
             (run_direction.left) then            
              p.x = p.x - 8
              show_boost = false
            elseif (show_boost) and 
             (run_direction.right) then
              p.x = p.x + 8
              show_boost = false
            end
        end
      end
    end

    if (p.x > 130) and (run_direction.left) then 
      print("-1", 120, 127, 2)
    end
    if (p.x < 80) and (run_direction.right) then
      print("-1", 120, 127, 2)
    end
    if (p.x < 130) and (run_direction.left) then
      print("+1", 120, 127, 5)
    end
    if (p.x > 80) and (run_direction.right) then
      print("+1", 120, 127, 5)    
    end 
    -- boundary check for player x pos    
    if (run_direction.left) then 
      if p.x > 130 or p.x < 130 then 
        if set_timer(1) then
          p.x = 130  -- reset x position
        end
      end
    end
    if (run_direction.right) then 
      if p.x > 80 or p.x < 80 then 
        if set_timer(1) then
          p.x = 80
        end
      end  
    end
  end 

  function object_col(ob_x, ob_y)
    if p.x +  8 > ob_x + 8  and 
       p.x +  8 < ob_x + 24  or
       p.x + 24 > ob_x + 8  and
       p.x + 24 < ob_x + 24 then  
      
      if p.y + 8  > ob_y      and
         p.y + 8  < ob_y + 24  or
         p.y + 28 > ob_y      and
         p.y + 28 < ob_y + 24 then  
         
         return true
      end
    end
  end
  
    function boost_col(bst_x, bst_y)
     if p.x      > bst_x      and 
        p.x      < bst_x + 16  or
        p.x + 16 > bst_x      and
        p.x + 16 < bst_x + 16 then         

       if p.y      > bst_y      and
          p.y      < bst_y + 16  or
          p.y + 16 > bst_y      and
          p.y + 16 < bst_y + 16  or  
          p.y + 24 > bst_y      and
          p.y + 24 < bst_y + 16 then         
         
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
    count = count - 1
    -- win/lose conditions
    if (cur_dist == 0) then
      game_over = true
    end
    if (count/60 == 0) then -- 60 for testing
      winner = true
    end
    -- update player y pos  
    p.y = p.y + p.y_vel
    -- "scroll" map
    run_map.cell_x = run_map.cell_x + run_map.speed
  end
 
  function looping_runner_logic()
    if (not game_over) then
      draw_level()
      runner_HUD()
      run_level_movement()
      generate_objects()
      draw_objects()
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

--make_system("looping_runner", looping_runner_init, looping_runner_loop)

--end looping_runner
