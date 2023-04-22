-- title:  Tunnel Chasers
-- Created by: MacklenF, AshBC, Sashami 
-- desc:   Looping Runner PrototypeV2
-- script: lua

function looping_runner_init()
 -- gsync(0, checkbank, false)
  fr=0
  bttn={u=0,d=1,l=2,r=3,z=4,x=5,a=6,s=7}
  selected_pc="pig"

  pc={x=55,y=78,sprId=256,CLRK=0,scale=2,flip=0,
    indx=1,changeFrame=false,CF=1,
    wait=30,isIdle=true,isRun=false,
    name={"pig","nul","par","byz"},
    iniSpr={256,288,320,352},
    spdTbl={0.8,0.65,0.75,0.7},
    sprites={}
  }

  for n=1,4 do
    local spr_id=pc.iniSpr[n]
    pc.sprites[n]={}
    for c=1,8 do
      pc.sprites[n][c]=spr_id
      spr_id=spr_id+2
    end
  end

  function pcSpr()
    if btnp(bttn.a,60,15) then 
      pc.indx=(pc.indx>1) and pc.indx-1 or 1
      selected_pc=pc.name[pc.indx]
      pc.sprId=pc.iniSpr[pc.indx]
    elseif btnp(bttn.s,60,15) then 
      pc.indx=(pc.indx<=3)and pc.indx+1 or 4
      selected_pc=pc.name[pc.indx]
      pc.sprId=pc.iniSpr[pc.indx]
    end
  end

  function mvChar()
    if btn(bttn.u) and ((pc.y+31)>99) then
      pc.y=pc.y-1
    elseif btn(bttn.d) and ((pc.y+31)<140) then
      pc.y=pc.y+1
    else 
      pc.isIdle=true
      pc.isRun=false
    end
    if btn(bttn.l) and ((pc.x+14)>=3) then 
      pc.x=pc.x-1
      pc.flip=1
    elseif btn(bttn.r) and ((pc.x+14)<=233) then 
      pc.x=pc.x+1
      pc.flip=0
    else 
      pc.isIdle=true
      pc.isRun=false
    end
    if btn(bttn.u) or btn(bttn.d) or btn(bttn.l) or btn(bttn.r) then
      pc.isIdle=false
      pc.isRun=true
      pc.changeFrame=true
    end
  end

  function animate()
    if pc.wait == 0 then
      pc.changeFrame=true
      pc.CF=(pc.CF==1) and 2 or 1
      if pc.isIdle then pc.wait=30
      elseif pc.isRun then pc.wait=15
      end
    end
    if pc.isIdle and pc.changeFrame then
      pc.sprId=pc.sprites[pc.indx][pc.CF]
      pc.changeFrame=false
    elseif pc.isRun and pc.changeFrame then
      pc.sprId=pc.sprites[pc.indx][pc.CF+4]
      pc.changeFrame=false
    end
  end
  
  function rt_draw()
    pcSpr()
	animate()
    if (pc.y >= 78) then
--		spr(418,officer.x+6,101,5,2,1,0,1,1)--shadow officer
--		spr(418,pc.x+6,pc.y+24,5,2,1,0,1,1)--shadow pc
        spr(officer.id,officer.x,78,0,2,officer.flip,0,2,2)--oficcer
        spr(pc.sprId,pc.x,pc.y,pc.CLRK,pc.scale,pc.flip,0,2,2)--pc
	else
--		spr(418,pc.x+6,102,5,2,1,0,1,1)--shadow pc
--		spr(418,officer.x+6,101,5,2,1,0,1,1)--shadow officer
        spr(pc.sprId,pc.x,pc.y,pc.CLRK,pc.scale,pc.flip,0,2,2)--pc
        spr(officer.id,officer.x,78,0,2,officer.flip,0,2,2)--officer
    end
  end

  function runner_sprsheet03()
    cls()
    map(mapX,34,30,17,0,0,-1)--bg
    map(decorX,decorY,30,17,0,3,0,2)--decorations
    rt_draw()	
    map(180,134,240,136,0,120,0)--overlay	
    fr=(fr+1)%60
    pc.wait=pc.wait-1
  end --- end sprsheet03 ---
--
-- desc:   Looping Runner
-- 
  local game_over = false
  local winner = false
  local t = 0
  local count = 30*60 -- game time*60/fps
  local wait_t = 60
  local y_vel = 0
  run_floor = 78 -- =player y pos
  jump_max = 60
  cur_dist = 6.0
  grav = 0.2     -- speed for jump fall   
  local obs = {} -- obstacles
  local boosts  = {}

  -- integrate sprsheet03 with runner
  officer = {x=200,id=486,flip=1}
  mapX   = 210 -- vars to "scroll" map
  decorX = 0 
  decorY = 51 
  
  local p = pc
  p.x = 152
  p.isIdle = false
  p.isRun=true
  p.changeFrame=true
  p.flip = 1
  mp_spd = -1/6

  -- set runner sprite info
  local function set_runSpr()   
    if pc.indx == 1 then
      jumpSpr_id  = 268
      slideSpr_id = 270
      hitSpr_id   = 384
      sprSpd = pc.spdTbl[1]
      sprHit = .75
    elseif pc.indx == 2 then
      jumpSpr_id  = 300
      slideSpr_id = 302
      hitSpr_id   = 386
      sprSpd = pc.spdTbl[2]
      sprHit = 1.5
    elseif pc.indx == 3 then
      jumpSpr_id  = 332
      slideSpr_id = 334
      hitSpr_id   = 388
      sprSpd = pc.spdTbl[3]
      sprHit = 1.0
    elseif pc.indx == 4 then
      jumpSpr_id  = 364
      slideSpr_id = 366
      hitSpr_id   = 390
      sprSpd = pc.spdTbl[4]
      sprHit = 1.25
    end
  end
  
  -- set runner direction
  run_dir = {right = false, left = false}
  run_dir.left = true
  -- defaults set to run left  
  new_ob_x = 0
  obs_spd = 2  
  bst_spd = .5
 
  function set_direction(run_dir)
    if (run_dir.right) then
      p.x = 58
      officer.x = 10
      mp_spd = -mp_spd
      p.flip = 0
      officer.flip = 0
      new_ob_x = 240
      obs_spd = -obs_spd 
      bst_spd = -bst_spd 
    end
  end
  set_direction(run_dir)
   
  function run_lvl_mv()
    if btnp(0) and (grounded) then
      y_vel = -2.5
      mid_jump = true      
      p.wait = 45
      p.sprId = jumpSpr_id
    end
    if btnp(1) and (grounded) then
      p.wait = 45
      p.sprId = slideSpr_id
      mid_slide = true
      wait_t = 45        
    end
  end
      
  function set_timer(n)
    if t > 0 then
      if (t/60) % n == 0 then -- every n seconds
        return true
      end
    end
  end
          
  function pos_check()
    if p.y == run_floor then 
      grounded = true 
    elseif p.y ~= run_floor then
      grounded = false  
    end
    if p.y < jump_max then
      y_vel = y_vel + grav
    end
    if (mid_slide) then
      if wait_t < 0 then 
        mid_slide = false 
      end    
    end
    if p.y > run_floor and (mid_jump) then
      p.y = run_floor
      y_vel = 0
      mid_jump = false
    end
  end
  
  function generate_obs()
    if set_timer(1.5) then
      need_object = true
    end
    if set_timer(12) then
      need_boost = true    
    end
    if (need_object) then
  	   obs[#obs+1] = 
      { id = math.random(234,239),
        xp  = new_ob_x,
        yp  = math.random(1,2),
        active = true
      }
    end
    need_object = false
    if (need_boost) then
      boosts[#boosts+1] = 
      { id = math.random(242,245),
        xp  = new_ob_x,
        yp  = math.random(40,60),
        active = true
      }
    end
    need_boost = false
  end

  function draw_obs()
    for i = 1,#obs do
      if obs[i] ~= nil then
        -- set obs y
        if obs[i].yp == 1 then obs[i].yp = 94     -- jump
        elseif obs[i].yp == 2 then obs[i].yp = 70 -- slide
        end
        spr(obs[i].id, obs[i].xp, -- draw obs
            obs[i].yp, 0, 2)
        obs[i].xp = obs[i].xp + obs_spd -- move obs
        if obs[i].xp > p.x + 32 and 
          (run_dir.left) then 
            obs[i].active = false
          if obs[i].xp > 240 then
            table.remove(obs, i)
          end
        elseif obs[i].xp + 32 < p.x and 
          (run_dir.right) then
            obs[i].active = false
          if obs[i].xp < 0 then
            table.remove(obs, i)
          end
        end
      end
    end
    for i = 1,#boosts do
      if boosts[i] ~= nil then
        spr(boosts[i].id, boosts[i].xp,
            boosts[i].yp, 0, 2)
        boosts[i].xp = boosts[i].xp + bst_spd
        if boosts[i].xp > p.x + 32 and 
          (run_dir.left) then 
            boosts[i].active = false
            if boosts[i].xp > 240 then
              table.remove(boosts, i)            
            end
        elseif boosts[i].xp + 32 < p.x and 
          (run_dir.right) then
            boosts[i].active = false
            if boosts[i].xp < 0 then
              table.remove(boosts, i)
            end  
        end
      end
    end
  end

  function collision()
    local check_dist = cur_dist
    for i = 1,#obs do
      if obs[i] ~= nil then
        if obs[i].active and
          (object_col(obs[i].xp, obs[i].yp)) then
            
            p.wait = 30
            p.sprId = hitSpr_id
            show_setback = true
            cur_dist = cur_dist - sprHit
            obs[i].active = false           
            if (show_setback) and 
              (run_dir.left) then
              officer.x = officer.x - 4  
              show_setback = false
            elseif (show_setback) and 
              (run_dir.right) then
              officer.x = officer.x + 4
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
            cur_dist = cur_dist + sprSpd
            boosts[i].active = false
            table.remove(boosts, i)            
            if (show_boost) and 
             (run_dir.left) then            
              officer.x = officer.x + 4
              show_boost = false
            elseif (show_boost) and 
             (run_dir.right) then
              officer.x = officer.x - 4
              show_boost = false
            end
        end
      end
    end
    -- check for collision number display
    if cur_dist > check_dist then
      display_boost = true
      wait_t = 60
    elseif cur_dist < check_dist then
      display_setback = true
      wait_t = 60
    end
  end 
  
  function display_col()
    if (display_boost) then
      if (display_setback) then display_boost = false end
        print("+ "..sprSpd, 100, 127, 5)
      if wait_t < 0 then display_boost = false end
    end
    if (display_setback) then
      if (display_boost) then display_setback = false end
        print("- "..sprHit, 100, 127, 2)
      if wait_t < 0 then display_setback = false end
    end
  end

  function object_col(ob_x, ob_y)
    if p.x + 12 > ob_x + 8  and 
       p.x + 12 < ob_x + 15  or
       p.x + 24 > ob_x + 8  and
       p.x + 24 < ob_x + 15 then  
      if (not mid_slide) then 
        if p.y + 4  > ob_y      and
           p.y + 4  < ob_y + 24  or
           p.y + 28 > ob_y      and
           p.y + 28 < ob_y + 24 then  
         
           return true
        end
      elseif (mid_slide) then
        if p.y + 12 > ob_y      and
           p.y + 12 < ob_y + 16  or
           p.y + 28 > ob_y      and
           p.y + 28 < ob_y + 16 then  
       
           return true
        end        
      end
    end
  end
  
  function boost_col(bst_x, bst_y)
    if p.x + 15 > bst_x      and
       p.x + 15 < bst_x + 15 then         
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
  
  function end_runner()
      count = 1
      t = 1
      mp_spd = 0 -- stop scrolling
      map(150,102,240,136,0,0,0)-- overlay end wall
      officer.id = 480+fr//30*2 -- idle officer
      p.isIdle = true
      p.changeFrame = false
      p.isRun = false
      obs_spd = 0
      bst_spd = 0
      need_object = false
      need_boost = false
      table.remove(obs, 1)  -- clear obs
      table.remove(boosts, 1)
      grounded = false -- stop run_lvl_mv
      mvChar()         -- free player movement
      if (winner) then 
        if (p.x < 50) then
          p.x = 50
          officer_result = "ran_away_success"
          current_system = "continue_menu"
        end 
        if (p.x > 160) then -- block from going back
          p.x = 160
        end
        if (p.y > 86) then
          p.y = 86
        end
      end
      if (game_over) then
        officer_result = "ran_away_fail"
        current_system = "continue_menu"      
      end
  end

  function update()
    t = t + 1
    count = count - 1
    wait_t = wait_t - 1
    -- animate officer
    officer.id = 486+t%60//15*2
    -- update player y pos  
    p.y = p.y + y_vel
    -- "scroll" map
    mapX = mapX + mp_spd*sprSpd
    decorX = decorX + mp_spd*sprSpd
	-- win/lose conditions
    if (cur_dist <= 0) then
      game_over = true
    end
    if (count/60 == 0) then -- 60 for testing
      winner = true
    end
    -- update display
    display_col()
    print("Distance: "..cur_dist,10,128,12,false,1,true)
    print("Time: "..math.floor((count/60)*10)/10,200,128,12,false,1,true)
  end
 
  function looping_runner_logic()
    if (not game_over) then
      runner_sprsheet03() -- sprsheet03 code
      -- runner level code
      set_runSpr()
      run_lvl_mv()
      generate_obs()
      draw_obs()
      pos_check()
      update()
      collision()
    end
    if (game_over) or (winner) then
      end_runner()
    end
  end
end -- end looping_runner init

looping_runner_init()

function looping_runner_loop()
  looping_runner_logic()
end

--make_system("looping_runner", looping_runner_init, looping_runner_loop)

--end looping_runner
