-- title:  Tunnel Chasers
-- Created by: MacklenF, AshBC, Sashami 
-- desc:   Looping Runner PrototypeV2
-- script: lua
 
function looping_runner_init()
  gsync(16,0,false)
  --music(1,0,0,true)
  fr=0
  bttn={u=0,d=1,l=2,r=3,z=4,x=5,a=6,s=7}
  selected_pc="pig"

  pc={x=55,y=78,sprId=256,CLRK=0,scale=2,flip=0,
      indx=1,changeFrame=false,CF=1,
      r_wait=30,isIdle=true,isRun=false,
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
  -- runner vars 
  local gm_state = {win=false,fail=false}
  local tm = {gm_ct=30*60, wt=60, intvl=0} -- timers
  local y_vel = 0
  run_floor = 78 -- =player y pos
  jump_max = 60
  cur_dist = 6.0
  grav = 0.2     -- speed for jump fall   
  local obs = {} -- obstacles
  local boosts  = {}

  ofc = {x=200,id=484,flip=1} --officer table
  -- officer vars
  o = {runId=488,idleId=480,hitId=492,FR=0,t=10}
  mapX = 210 
  decor = {x=210, y=34} 
  
  local p = pc
  p.x = 152
  p.isIdle = false
  p.isRun=true
  p.changeFrame=true
  p.flip = 1
  mp_spd = -.25

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

  function rt_animate()
    if pc.r_wait == 0 then
      pc.changeFrame=true
      pc.CF=(pc.CF==1) and 2 or 1
      if pc.isIdle then pc.r_wait=30
      elseif pc.isRun then pc.r_wait=15
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
    rt_animate()
    if (pc.y >= 78) then
      spr(445,ofc.x+6,101,5,2,1,0,1,1)--shadow officer
      spr(445,pc.x+8,pc.y+24,5,2,1,0,1,1)--shadow pc
      spr(ofc.id+o.FR//20*2,ofc.x,78,0,2,ofc.flip,0,2,2)--oficcer
      spr(pc.sprId,pc.x,pc.y,pc.CLRK,pc.scale,pc.flip,0,2,2)--pc
    else
      spr(445,pc.x+8,102,5,2,1,0,1,1)--shadow pc
      spr(445,ofc.x+6,101,5,2,1,0,1,1)--shadow officer
      spr(pc.sprId,pc.x,pc.y,pc.CLRK,pc.scale,pc.flip,0,2,2)--pc
      spr(ofc.id+o.FR//20*2,ofc.x,78,0,2,ofc.flip,0,2,2)--officer
    end
  end

  function print_debug(color)
    print("Press A or S to change character",0,0,color or 3)	
    print("Change frame: "..pc.CF,0,7,color or 12)
    print(", ID: "..pc.sprId,83,7,color or 12)
    print(", Character: "..selected_pc,126,7,color or 12)
    print("UP to jump  DOWN to slide",0,14,color or 3)
    print("player y: "..p.y,160,14,12)	
  end

  function runner_sprsheet03()
    cls()
    vbank(0)
    map(mapX,17,30,17,0,0,-1)--bg
    map(decor.x,decor.y,30,17,0,3,0,2)--decorations
    vbank(1)
    poke(0x03FF8,0)
    map(mapX,17,30,17,0,0,-1)--bg
    map(decor.x,decor.y,30,17,0,3,0,2)--decorations
    rt_draw()

    fr=(fr+1)%60
    pc.r_wait=pc.r_wait-1
    o.t = o.t-1
    if ofc_state == "hit" then
      o.FR = 1
    end
    if ofc_state == "run" then  
      o.FR=(o.FR+1)%40
    end
  end --- end sprsheet03 ---

  -- set runner anim sprites
  local function set_runSpr()   
    if pc.indx == 1 then
      jumpSpr_id  = 268
      slideSpr_id = 270
      hitSpr_id   = 416
      sprSpd = pc.spdTbl[1]
      sprHit = .75
    elseif pc.indx == 2 then
      jumpSpr_id  = 300
      slideSpr_id = 302
      hitSpr_id   = 418
      sprSpd = pc.spdTbl[2]
      sprHit = 1.5
    elseif pc.indx == 3 then
      jumpSpr_id  = 332
      slideSpr_id = 334
      hitSpr_id   = 420
      sprSpd = pc.spdTbl[3]
      sprHit = 1.0
    elseif pc.indx == 4 then
      jumpSpr_id  = 364
      slideSpr_id = 366
      hitSpr_id   = 422
      sprSpd = pc.spdTbl[4]
      sprHit = 1.25
    end
  end
  
  -- set runner direction
  run_dir = {right = false, left = false}
  run_dir.right = true
  -- defaults set to run left  
  new_ob_x = 0
  obs_spd = 2  
  bst_spd = .5
  end_wallX = 0

  function set_direction(run_dir)
    if (run_dir.right) then
      p.x = 58
      ofc.x = 10
      mp_spd = -mp_spd
      p.flip = 0
      ofc.flip = 0
      new_ob_x = 240
      end_wallX = 29
      obs_spd = -obs_spd 
      bst_spd = -bst_spd 
    end
  end
  set_direction(run_dir)
   
  function run_lvl_mv()
    if btnp(0) and (grounded) then
      y_vel = -2.5
      mid_jump = true      
      p.r_wait = 45
      p.sprId = jumpSpr_id
    end
    if btnp(1) and (grounded) then
      p.r_wait = 45
      p.sprId = slideSpr_id
      mid_slide = true
      tm.wt = 45        
    end
  end
      
  function set_timer(n)
    if tm.intvl > 0 then
      if (tm.intvl/60) % n == 0 then -- every n seconds
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
      if tm.wt < 0 then 
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
        -- rand obs y
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
           
            p.r_wait = 30
            p.sprId = hitSpr_id
            show_setback = true
            cur_dist = cur_dist - sprHit
            obs[i].active = false           
            if (show_setback) and 
              (run_dir.left) then
              ofc.x = ofc.x - 4  
              show_setback = false
            elseif (show_setback) and 
              (run_dir.right) then
              ofc.x = ofc.x + 4
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
              ofc.x = ofc.x + 4
              show_boost = false
            elseif (show_boost) and 
             (run_dir.right) then
              ofc.x = ofc.x - 4
              show_boost = false
            end
        end
      end
    end
    -- check for collision number display
    if cur_dist > check_dist then
      display_boost = true
      tm.wt = 60
    elseif cur_dist < check_dist then
      display_setback = true
      tm.wt = 60
    end
  end 
  
  function display_col()
    if (display_boost) then
      if (display_setback) then display_boost = false end
        print("+ "..sprSpd, 100, 127, 5)
      if tm.wt < 0 then display_boost = false end
    end
    if (display_setback) then
      if (display_boost) then display_setback = false end
        print("- "..sprHit, 100, 127, 2)
      if tm.wt < 0 then display_setback = false end
    end
  end
  
  function ofc_col()
    for i = 1,#obs do
      if obs[i] ~= nil then
        if (run_dir.left) then 
          if ofc.x <= obs[i].xp+7 then
            ofc_state = "hit"
            ofc.id = o.hitId
            o.t = 8
            table.remove(obs, i)
          end
        end
        if (run_dir.right) then 
          if ofc.x+31 >= obs[i].xp then
            ofc_state = "hit"
            ofc.id = o.hitId
            o.t = 8
            table.remove(obs, i)
          end
        end
      end
    end
    if o.t <= 0 then
       ofc_state="run"
       ofc.id=o.runId
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
      tm.gm_ct = 1
      tm.intvl = 1
      mp_spd = 0 -- stop scrolling
      o.t=1
      ofc.id=o.idleId
      obs_spd = 0
      bst_spd = 0
      need_object = false
      need_boost = false
      table.remove(obs, 1)  -- clear obs
      table.remove(boosts, 1)
      grounded = false -- stop run_lvl_mv
      if (gm_state.win) then 
        rt_draw()
        if (run_dir.left) then 
          p.x = p.x - 1
          if p.x <= 16 then
            p.x = 16
            p.isIdle = true
            p.isRun=false
            officer_result = "ran_away_success"
            current_system = "continue_menu"
          end
        end
        if (run_dir.right) then 
          p.x = p.x + 1 
          if p.x >= 192 then
            p.x = 192
            p.isIdle = true
            p.isRun=false
            officer_result = "ran_away_success"
            current_system = "continue_menu"
          end
        end
      end
      if (gm_state.fail) then
        officer_result = "ran_away_fail"
        current_system = "continue_menu"      
      end
  end

  function update()
    tm.intvl = tm.intvl + 1
    tm.gm_ct = tm.gm_ct - 1
    tm.wt = tm.wt - 1
    p.y = p.y + y_vel
    -- "scroll" map
    mapX = mapX + mp_spd*sprSpd
    decor.x = decor.x + mp_spd*sprSpd
    -- win/lose conditions
    if (cur_dist <= 0) then
      gm_state.fail = true
    end
    if (tm.gm_ct/60 < 5) then
      if (run_dir.left) then
	      map(0+tm.gm_ct/60*16,51,240,136,0,0,0)
      end
      if (run_dir.right) then
       map(240-tm.gm_ct/60*16,68,240,136,0,0,0) 
      end
    end
    if (tm.gm_ct/60 == 0) then -- 60 for testing
      gm_state.win = true
    end
  end
  
  function run_display()
    print_debug()
    map(180,134,240,136,0,120,0)--overlay	
    display_col()
    print("Distance: "..cur_dist,6,128,12,false,1,true)
    print("Time: "..math.floor((tm.gm_ct/60)*10)/10,200,128,12,false,1,true)
  end
 
  function looping_runner_logic()
    if (not gm_state.fail) then
      runner_sprsheet03()
      set_runSpr()
      run_lvl_mv()
      generate_obs()
      draw_obs()
      pos_check()
      update()
      ofc_col()
      collision()
      run_display()
    end
    if (gm_state.fail) or (gm_state.win) then
      end_runner()
    end
  end
end -- end looping_runner init

looping_runner_init()
  
function looping_runner_loop()
 -- gsync(1|2|4|8|32|64|128, 2, false)  
  looping_runner_logic()
end

--make_system("looping_runner", looping_runner_init, looping_runner_loop)

--end looping_runner
