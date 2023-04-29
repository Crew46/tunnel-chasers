---
--- Created by AshBC.
--- Creation DateTime: 03/25/23 10:00 AM
--- Backup DateTime: 04/28/23 6:55 PM
--- graphics library

fr=0
--bttn={u=0,d=1,l=2,r=3,z=4,x=5,a=6,s=7}
bttn={u=0,d=1,l=2,r=3,w=23,s=19,a=1,d=4,q=17,e=5,z=26,x=24,shift=64}

function pcSpr_change()
	if keyp(bttn.q,60,15) then 
		pc.indx=(pc.indx>1) and pc.indx-1 or 1
		pc.selected=pc.nameTbl[pc.indx]
		pc.spr_Id_h=pc.sprTbl[pc.indx]
		pc.spr_Id_b=pc.spr_Id_h+8
		pc.speed=pc.spdTbl[pc.indx]
	elseif keyp(bttn.e,60,15) then 
		pc.indx=(pc.indx<=4)and pc.indx+1 or 5
  		pc.selected=pc.nameTbl[pc.indx]
		pc.spr_Id_h=pc.sprTbl[pc.indx]
		pc.spr_Id_b=pc.spr_Id_h+8
		pc.speed=pc.spdTbl[pc.indx]
	end
	print("Head: "..pc.spr_Id_h,0,6,6)
 	print("Body: "..pc.spr_Id_b,60,6,6)
	print("Selected char: "..pc.selected,0,12,6)
end

function resetPos()
	if keyp(bttn.z,60,15) then
		pc.x=70
		pc.y=75
	end
end

function pcActions()
	local hold=1
 	local diag_rate=0.78
	local rate=pc.speed
	local hor_spd=0
	local ver_spd=0
	local period=key(bttn.shift) and 2 or 1
	
	--Diagonal speed change
	if ((key(bttn.w) or key(bttn.s)) 
	and (key(bttn.a) or key(bttn.d))) then
		rate=rate*diag_rate
	end
	
	--Block unwanted input
	if ((key(bttn.a) and key(bttn.d)) 
		or (key(bttn.w) and key(bttn.s))
		or ((key(bttn.a) and key(bttn.d)) and (key(bttn.w) or key(bttn.s)))
		or ((key(bttn.w) and key(bttn.s)) and (key(bttn.a) or key(bttn.d))))
		and key(bttn.shift) then 
			hor_spd=0
			ver_spd=0
	else
		--Horizontal speed
		if keyp(bttn.a,hold,period) then 
			pc.flip=1
			hor_spd=hor_spd-rate
		elseif keyp(bttn.d,hold,period) then 
			pc.flip=0
			hor_spd=hor_spd+rate
		end
		
		--Vertical speed
		if keyp(bttn.w,hold,period) then
			pc.isTurned=true
			ver_spd=ver_spd-rate
		elseif keyp(bttn.s,hold,period) then
			pc.isTurned=false
			ver_spd=ver_spd+rate
		end
	end

	--Change player state
	pc.isCrouch=(key(bttn.shift)) and true or false

	if ((key(bttn.a) and key(bttn.d))
	or (key(bttn.w) and key(bttn.s))) 
	and key(bttn.shift) then
		pc.isIdle=true
		pc.isRun=false
		pc.state="Idle"
		pc.changeFrame=true
	elseif (key(bttn.w) or key(bttn.s) 
	or key(bttn.a) or key(bttn.d))
	and isCrouch then
		pc.isIdle=false
		pc.isRun=false
		pc.state="Crouched"
		pc.changeFrame=true
	elseif key(bttn.w) or key(bttn.s) 
	or key(bttn.a) or key(bttn.d) then
		pc.isIdle=false
		pc.isRun=true
		pc.state="Running"
		pc.changeFrame=true
	else 
		pc.isIdle=true
		pc.isRun=false
		pc.state="Idle"
		pc.changeFrame=true
	end

	pc.x=pc.x+hor_spd
	pc.y=pc.y+ver_spd

end

function animate()
	print("Change frame: "..pc.CF,0,18,6)
  	print("Change frame timer: "..pc.CF_timer,30,0,6)
	print("PC state: "..pc.state,50,70,12)
	if pc.CF_timer == 0 then
		pc.changeFrame=true
		pc.CF=(pc.CF==1) and 2 or 1
		if pc.isIdle then pc.CF_timer=30
		elseif pc.isRun or pc.isCrouch then pc.CF_timer=15
		end
	end
	if pc.isIdle and pc.changeFrame then
		if not pc.isTurned then
			pc.spr_Id_h=pc.sprites[pc.indx][pc.CF]
			pc.spr_Id_b=pc.sprites[pc.indx][pc.CF+4]
			pc.changeFrame=false
		else
			pc.spr_Id_h=pc.sprites[pc.indx][pc.CF+2]
			pc.spr_Id_b=pc.sprites[pc.indx][pc.CF+6]
			pc.changeFrame=false
		end
	elseif pc.isCrouch and pc.changeFrame then
		if not pc.isTurned then
			pc.spr_Id_h=pc.sprites[pc.indx][2]
			pc.spr_Id_b=pc.sprites[pc.indx][pc.CF+12]
			pc.changeFrame=false
		else
			pc.spr_Id_h=pc.sprites[pc.indx][4]
			pc.spr_Id_b=pc.sprites[pc.indx][pc.CF+14]
			pc.changeFrame=false
		end
	elseif pc.isRun and pc.changeFrame then
		if not pc.isTurned then
			pc.spr_Id_h=pc.sprites[pc.indx][1]
			pc.spr_Id_b=pc.sprites[pc.indx][pc.CF+8]
			pc.changeFrame=false
		else
			pc.spr_Id_h=pc.sprites[pc.indx][3]
			pc.spr_Id_b=pc.sprites[pc.indx][pc.CF+10]
			pc.changeFrame=false
		end
	end
end

function drawpc()
	pcSpr_change()
	pcActions()
	resetPos()
	animate()
	spr(pc.spr_Id_h,pc.x,pc.y-8,pc.CLRK,pc.scale,pc.flip,0,2,1)
 	spr(pc.spr_Id_b,pc.x,pc.y,pc.CLRK,pc.scale,pc.flip,0,2,1)
	print("Frame: "..fr,0,130,6)
	fr=(fr+1)%60
	pc.CF_timer=pc.CF_timer-1	
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
				map(15,0,15,9,0,0,0,2)
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
