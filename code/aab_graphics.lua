---
--- Created by AshBC.
--- DateTime: 03/25/23 10:00 AM
--- graphics library

fr=0
--bttn={u=0,d=1,l=2,r=3,z=4,x=5,a=6,s=7}
--bttn={u=0,d=1,l=2,r=3,w=23,s=19,a=1,d=4,q=17,e=5,z=26,x=24,shift=64}

G_DEBUG = false
npc_cf=0
musicPlaying=false

function npc_anim(pose1,pose2,x,y,scale)
	if (fr%30)==0  then
		npc_cf=(npc_cf==0) and 1 or 0
		npc_pose=(npc_cf==0) and pose1 or pose2
	end
	spr(npc_pose,x,y,0,scale,0,0,2,2)
end

function pcSpr_change()
	if keyp(17,60,15) then 
		player.indx=(player.indx>1) and player.indx-1 or 1
		player.selected=player.nameTbl[player.indx]
		player.spr_Id_h=player.sprTbl[player.indx]
		player.spr_Id_b=player.spr_Id_h+8
		player.speed=player.spdTbl[player.indx]
	elseif keyp(5,60,15) then 
		player.indx=(player.indx<=4)and player.indx+1 or 5
  		player.selected=player.nameTbl[player.indx]
		player.spr_Id_h=player.sprTbl[player.indx]
		player.spr_Id_b=player.spr_Id_h+8
		player.speed=player.spdTbl[player.indx]
	end

	if G_DEBUG == true then
		if G_DEBUG == true then
			rect(0, 0, 120, 36, 2)
		end
		print("Head: "..player.spr_Id_h,0,6,6)
		print("Body: "..player.spr_Id_b,60,6,6)
		print("Selected char: "..player.selected,0,12,6)
	end
end

function pcActions()
	-- functions local constants
	local FLAG_COLLISION = 0
	local rollover_amount = 4
	local overlay_offset = {
		x = 120 * 8,
		y = 0
	}

	-- button press hold and period... period is 2 if player
	-- is sneaking (pressing Shift key)
	local hold   = 1
	local period = key(64) and 2 or 1

	-- rate of movement, and speeds of character
	local rate    = player.speed
	local hor_spd = 0
	local ver_spd = 0

	-- if player is moving diagonally, apply diagonal rate
	if ((btn(0) or btn(1))  and
		(btn(2) or btn(3))) then
		rate = rate * 0.78
	end

	----------------------------------
	-- Player pressed up button.    --
	----------------------------------
	if btnp(0, hold, period) then
		-- points that may end up colliding
		collisionPoints = collisionbox_flagchecks(FLAG_COLLISION, {0, 1}, {roofCheck = 1})

		-- a middle collision point between top-left and top-right
		middleCollided = collisionbox_flagcheck(FLAG_COLLISION, 0, {wallCheck = -4, roofCheck = 1})

		if #collisionPoints == 0 and not middleCollided then
			player.isTurned = true
			ver_spd = ver_spd - rate
		end
	end
	----------------------------------
	-- Player pressed down button.  --
	----------------------------------
	if btnp(1, hold, period) then
		-- points that may end up colliding
		collisionPoints = collisionbox_flagchecks(FLAG_COLLISION, {2, 3}, {roofCheck = 1})

		-- a middle collision point between top-left and top-right
		middleCollided = collisionbox_flagcheck(FLAG_COLLISION, 2, {wallCheck = -4, roofCheck = 1})

		if #collisionPoints == 0 and not middleCollided then
			player.isTurned = false
			ver_spd = ver_spd + rate
		end
	end
	----------------------------------
	-- Player pressed left button.  --
	----------------------------------
	if btnp(2, hold, period) then
		-- points that may end up colliding
		collisionPoints = collisionbox_flagchecks(FLAG_COLLISION, {0, 2}, {wallCheck = 1})

		if #collisionPoints == 0 then
			player.flip = 1
			player.isTurned = btn(0)
			hor_spd = hor_spd - rate
		end
	end
	----------------------------------
	-- Player pressed right button. --
	----------------------------------
	if btnp(3, hold, period) then
		-- points that may end up colliding
		collisionPoints = collisionbox_flagchecks(FLAG_COLLISION, {1, 3}, {wallCheck = 1})

		if #collisionPoints == 0 then
			player.flip = 0
			player.isTurned = btn(0)
			hor_spd = hor_spd + rate
		end
	end

	player.isCrouch = (key(64)) and true or false

	if (((btn(2) and btn(3)) 
	or (btn(0) and btn(1))
	or ((btn(2) and btn(3)) and (btn(0) or btn(1)))
	or ((btn(0) and btn(1)) and (btn(2) or btn(3))))
	and key(64)) 
	or ((btn(2) and btn(3)) or (btn(0) and btn(1))) then
		hor_spd=0
		ver_spd=0
		player.flip=0
		player.isTurned=false
		player.isIdle=true
		player.isRun=false
		player.state="Idle"
		player.changeFrame=true
	elseif (btn(0) or btn(1) or btn(2) or btn(3))
	and player.isCrouch then
		player.isIdle=false
		player.isRun=false
		player.state="Crouched"
		player.changeFrame=true
	elseif btn(0) or btn(1) or btn(2) or btn(3) then
		player.isIdle=false
		player.isRun=true
		player.state="Running"
		player.changeFrame=true
	else 
		player.isIdle=true
		player.isRun=false
		player.state="Idle"
		player.changeFrame=true
	end

	player.x = player.x + hor_spd
	player.y = player.y + ver_spd
end

function animate_chr()
	if G_DEBUG == true then
		print("Change frame timer: "..player.CF_timer,0,0,6)
		print("Change frame: "..player.CF,0,18,6)
		print("PC state: "..player.state,0,24,6)
		print("Speed: " ..player.speed,0,30,6)
	end

	if player.CF_timer == 0 then
		player.changeFrame=true
		player.CF=(player.CF==1) and 2 or 1
		if player.isIdle then player.CF_timer=30
		elseif player.isRun or player.isCrouch then player.CF_timer=15
		end
	end
	if player.isIdle and player.changeFrame then
		if not player.isTurned then
			player.spr_Id_h=player.sprites[player.indx][player.CF]
			player.spr_Id_b=player.sprites[player.indx][player.CF+4]
			player.changeFrame=false
		else
			player.spr_Id_h=player.sprites[player.indx][player.CF+2]
			player.spr_Id_b=player.sprites[player.indx][player.CF+6]
			player.changeFrame=false
		end
	elseif player.isCrouch and player.changeFrame then
		if not player.isTurned then
			player.spr_Id_h=player.sprites[player.indx][2]
			player.spr_Id_b=player.sprites[player.indx][player.CF+12]
			player.changeFrame=false
		else
			player.spr_Id_h=player.sprites[player.indx][4]
			player.spr_Id_b=player.sprites[player.indx][player.CF+14]
			player.changeFrame=false
		end
	elseif player.isRun and player.changeFrame then
		if not player.isTurned then
			player.spr_Id_h=player.sprites[player.indx][1]
			player.spr_Id_b=player.sprites[player.indx][player.CF+8]
			player.changeFrame=false
		else
			player.spr_Id_h=player.sprites[player.indx][3]
			player.spr_Id_b=player.sprites[player.indx][player.CF+10]
			player.changeFrame=false
		end
	end
end

function drawpc()
	pcSpr_change()
	pcActions()
	animate_chr()
	spr(player.spr_Id_h,player.x,player.y-8,player.CLRK,player.scale,player.flip,0,2,1)
 	spr(player.spr_Id_b,player.x,player.y,player.CLRK,player.scale,player.flip,0,2,1)
	if G_DEBUG == true then
		print("Frame: "..fr,0,130,6)
	end
	fr=(fr+1)%60
	player.CF_timer=player.CF_timer-1	
end

function draw(sprite_name, sprite_variant, x, y, scale)
	local sprite_number
	local color_key = -1
	local flip = 0
	local rotate = 0
	local width = 1
	local height = 1
	local draw_portrait = false
	if sprite_name then
	 	if sprite_name == "player_portrait" then
			draw_portrait = true
			local head_portraits = {256,288,320,352,384}
			local body_portraits = {264,296,328,360,392}
			sprite_number_head = head_portraits[sprite_variant]
			sprite_number_body = body_portraits[sprite_variant]
			width = 2
			height = 1
		elseif sprite_name == "player_portrait_box" then
			draw_portrait = false
			rectb(x, y, 32, 32, 11)
		elseif sprite_name == "title_screen" then
			local title = intro_frames[sprite_variant]
			if title.text == "CCC" then
				map(0,0,15,9,0,0,-1,2)
			elseif title.text == "Lab46" then
				cls(0)
				map(15,0,15,8,0,0,0,2)
			elseif title.text == "Crew46" then
				cls(0)
				map(0,9,8,3,55,44,0,2)
			end
	  	end
	end
	if draw_portrait and sprite_number_head and sprite_number_body then
	  spr(sprite_number_head, x, y, color_key, scale or 1, flip, rotate, width, height)
	  spr(sprite_number_body, x, y+16, color_key, scale or 1, flip, rotate, width, height)
	end
end

-- end graphics
