-- title:  Tunnel Chasers
-- Created by: MacklenF, AshBC, Sashami 
-- desc:   Looping Runner PrototypeV2
-- script: lua

function looping_runner_init()
  do_once=true
  fr=0
  bttn={u=0,d=1,l=2,r=3,z=4,x=5,a=6,s=7}
  local tm = {gm_ct=30*60, wt=60, intvl=0} -- timers
  local gm_state = {win=false,fail=false}
  local obs = {} -- obstacles
  local boosts  = {}
  local y_vel = 0
  local mp_spd = -.3
  run_floor = 78 -- =player y pos
  jump_max = 70
  cur_dist = 6.0
  grav = 0.2     -- speed for jump fall
  mapX = 0
  decor = {x=0,y=34}  
  -- officer table
  ofc = { x=200,id=484,runId=488,idleId=480,hitId=492,
         flip=1,FR=0,t=30 }
  ofc_state = "run"		 
  -- init rt_pc
  selected_pc="pig"

  rt_pc={x=55,y=78,sprId=256,CLRK=0,scale=2,flip=0,
	  indx=1,changeFrame=false,CF=1,
	  wait=30,isIdle=true,isRun=false,
	  name={"pig","nul","par","byz"},
 	  iniSpr={256,288,320,352},
   spdTbl={0.8,0.65,0.75,0.7},
	  sprites={}
  }

  for n=1,4 do
	  local spr_id=rt_pc.iniSpr[n]
	  rt_pc.sprites[n]={}
	  for c=1,8 do
		  rt_pc.sprites[n][c]=spr_id
		  spr_id=spr_id+2
	  end
  end
  -- set player 
  rt_pc.x = 152
  rt_pc.isIdle = false
  rt_pc.isRun=true
  rt_pc.changeFrame=true
  rt_pc.flip = 1   
  -- set player speeds
  for i=1,4 do
    if selected_pc == rt_pc.name[i] then
      rt_pc.indx = i
      sprSpd = rt_pc.spdTbl[i]
    end
  end
  tm.gm_ct = tm.gm_ct/sprSpd -- set game time

  local function set_runSpr()   
    if rt_pc.indx == 1 then
      jumpSpr_id  = 268
      slideSpr_id = 270
      hitSpr_id   = 416
      sprHit = .75
    elseif rt_pc.indx == 2 then
      jumpSpr_id  = 300
      slideSpr_id = 302
      hitSpr_id   = 418
      sprHit = 1.5
    elseif rt_pc.indx == 3 then
      jumpSpr_id  = 332
      slideSpr_id = 334
      hitSpr_id   = 420
      sprHit = 1.0
    elseif rt_pc.indx == 4 then
      jumpSpr_id  = 364
      slideSpr_id = 366
      hitSpr_id   = 422
      sprHit = 1.25
    end
  end
  local p = rt_pc -- ref to rt_pc for runner
  
function rt_pcSpr()
	if btnp(bttn.a,60,15) then 
		rt_pc.indx=(rt_pc.indx>1) and rt_pc.indx-1 or 1
		selected_pc=rt_pc.name[rt_pc.indx]
		rt_pc.sprId=rt_pc.iniSpr[rt_pc.indx]
	elseif btnp(bttn.s,60,15) then 
		rt_pc.indx=(rt_pc.indx<=3)and rt_pc.indx+1 or 4
		selected_pc=rt_pc.name[rt_pc.indx]
		rt_pc.sprId=rt_pc.iniSpr[rt_pc.indx]
	end
end

function rt_animate()
	if rt_pc.wait == 0 then
		rt_pc.changeFrame=true
		rt_pc.CF=(rt_pc.CF==1) and 2 or 1
		if rt_pc.isIdle then rt_pc.wait=30
		elseif rt_pc.isRun then rt_pc.wait=15
		end
	end
	if rt_pc.isIdle and rt_pc.changeFrame then
		rt_pc.sprId=rt_pc.sprites[rt_pc.indx][rt_pc.CF]
		rt_pc.changeFrame=false
	elseif rt_pc.isRun and rt_pc.changeFrame then
		rt_pc.sprId=rt_pc.sprites[rt_pc.indx][rt_pc.CF+4]
		rt_pc.changeFrame=false
	end
end
  
function rt_draw()
	rt_pcSpr()
	rt_animate()
	if (rt_pc.y >= 78) then
		spr(445,ofc.x+6,101,5,2,1,0,1,1)--shadow officer
		spr(445,rt_pc.x+8,rt_pc.y+24,5,2,1,0,1,1)--shadow rt_pc
		spr(ofc.id+ofc.FR//20*2,ofc.x,78,0,2,ofc.flip,0,2,2)--oficcer
		spr(rt_pc.sprId,rt_pc.x,rt_pc.y,rt_pc.CLRK,rt_pc.scale,rt_pc.flip,0,2,2)--rt_pc
	else
		spr(445,rt_pc.x+8,102,5,2,1,0,1,1)--shadow rt_pc
		spr(445,ofc.x+6,101,5,2,1,0,1,1)--shadow officer
		spr(rt_pc.sprId,rt_pc.x,rt_pc.y,rt_pc.CLRK,rt_pc.scale,rt_pc.flip,0,2,2)--rt_pc
		spr(ofc.id+ofc.FR//20*2,ofc.x,78,0,2,ofc.flip,0,2,2)--officer
	end
end

function print_debug(color)
	print("Press A or S to change character",0,0,color or 3)	
	print("Change frame: "..rt_pc.CF,0,7,color or 12)
	print(", ID: "..rt_pc.sprId,83,7,color or 12)
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
	rt_pc.wait=rt_pc.wait-1
	ofc.t = ofc.t-1
	if ofc_state == "hit" then
	  ofc.FR = 1
	end
	if ofc_state == "run" then  
	  ofc.FR=(ofc.FR+1)%40
 end
end --- end sprsheet03 ---

  -- set runner direction
  run_dir = {right = false, left = false}
  run_dir.left = true
  -- defaults set to run left  
  new_ob_x = 0
  obs_spd = 4  
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
	     p.wait = 45
      p.sprId = jumpSpr_id
    end
    if btnp(1) and (grounded) then
      p.wait = 30
      p.sprId = slideSpr_id
      mid_slide = true
      tm.wt = 30        
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
    if set_timer(10) then
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
        yp  = math.random(50,60),
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
           
            p.wait = 30
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
            ofc.id = ofc.hitId
            ofc.t = 8
            table.remove(obs, i)
          end
        end
        if (run_dir.right) then 
          if ofc.x+31 >= obs[i].xp then
            ofc_state = "hit"
            ofc.id = ofc.hitId
            ofc.t = 8
            table.remove(obs, i)
          end
        end
      end
    end
    if ofc.t <= 0 then
       ofc_state="run"
       ofc.id=ofc.runId
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
  
  function update()
    tm.intvl = tm.intvl + 1
    tm.gm_ct = tm.gm_ct - 1
    tm.wt = tm.wt - 1
    p.y = p.y + y_vel
    -- "scroll" map
    mapX = mapX + mp_spd*sprSpd
    decor.x = decor.x + (mp_spd*sprSpd)/2
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
    if (tm.gm_ct/60 <= 0) then -- 60 for testing
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
  
  function end_runner()
    tm.gm_ct = 1
    tm.intvl = 1
    mp_spd = 0 -- stop scrolling
    ofc.t=1
    ofc.id=ofc.idleId
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
        map(0,85,240,136,0,0,0) -- end overlay
        if p.x <= 0 then
          p.isIdle = true
          p.isRun=false
          print("Win. Enter next system",120,75,2)
          officer_result = "ran_away_success"
          current_system = "interior_level"
        end
      end
      if (run_dir.right) then 
        p.x = p.x + 1
        map(28,102,240,136,224,0,0) -- overlay 
        if p.x >= 240 then
          p.isIdle = true
          p.isRun=false
          print("Win. Enter next system",120,75,2)
          officer_result = "ran_away_success"
          current_system = "interior_level"
        end
      end
    end
    if (gm_state.fail) then
      print("Fail. Enter next system",120,75,2)
      officer_result = "ran_away_fail"
      current_system = "continue_menu_splash"
    end
	print_debug()
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

  function looping_runner_avini()
    if do_once then
      gsync(0,3,false)--sync all assets
      gsync(8|16,0)--sync music&sfx
      check_music(6)
      play_music(musicTrack,0,0,true)
      vbank(0)
      selected_pc=pc.selected
      rt_pc.indx=pc.indx
      do_once=false
    end
  end
end -- end looping_runner init

looping_runner_init()

function looping_runner_loop()
  looping_runner_avini()
  looping_runner_logic()
end

make_system("looping_runner", looping_runner_init, looping_runner_loop)

--end looping_runner
