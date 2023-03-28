---
--- Created by AshBC.
--- DateTime: 03/25/23 10:00 AM
--- graphics library

fr=0
--bttn={u=0,d=1,l=2,r=3,z=4,x=5,a=6,s=7}
bttn={u=0,d=1,l=2,r=3,w=23,s=19,a=1,d=4,q=17,e=5,z=26,x=24}

pc={x=240/2,y=136/2,
	spr_Id_h=256,spr_Id_b=264,CLRK=0,scale=1,flip=0,
	changeFrame=false,CF=1,CF_timer=30,
	isIdle=true,isRun=false,isTurned=false,
	indx=1,selected="pig",speed=1,
	nameTbl={"pig","nul","par","byz"},
  	sprTbl={256,288,320,352},
  	spdTbl={0.8,0.65,0.75,0.7},
	sprites={}
}

for n=1,4 do
	local spr_id=pc.sprTbl[n]
	pc.sprites[n]={}
	for c=1,16 do
		pc.sprites[n][c]=spr_id
		spr_id=spr_id+2
	end
end

function pcSpr_change()
	if keyp(bttn.q,60,15) then 
		pc.indx=(pc.indx>1) and pc.indx-1 or 1
    	pc.selected=pc.nameTbl[pc.indx]
    	pc.spr_Id_h=pc.sprTbl[pc.indx]
    	pc.spr_Id_b=pc.spr_Id_h+8
    	pc.speed=pc.spdTbl[pc.indx]
	elseif keyp(bttn.e,60,15) then 
		pc.indx=(pc.indx<=3)and pc.indx+1 or 4
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

function mvChar()
	local hold=1
 	local period=1
 	local rate=0.707
	local spd=pc.speed

  	if (keyp(bttn.w,hold,period) and (keyp(bttn.a,hold,period) or keyp(bttn.d,hold,period))) 
	or (keyp(bttn.s,hold,period) and (keyp(bttn.a,hold,period) or keyp(bttn.d,hold,period))) then
		spd=spd*rate
	end
    
	if keyp(bttn.w,hold,period) then
		pc.isTurned=true
		pc.y=pc.y-spd
	elseif keyp(bttn.s,hold,period) then
		pc.isTurned=false
		pc.y=pc.y+spd
	end

	if keyp(bttn.a,hold,period) then 
		pc.flip=1
    	pc.x=pc.x-spd
	elseif keyp(bttn.d,hold,period) then 
		pc.flip=0
    	pc.x=pc.x+spd
	end

	if keyp(bttn.w,hold,period) or keyp(bttn.s,hold,period) or keyp(bttn.a,hold,period) or keyp(bttn.d,hold,period) then
		pc.isIdle=false
		pc.isRun=true
		pc.changeFrame=true
	else 
		pc.isIdle=true
		pc.isRun=false
	end
	--if keyp(bttn.x,60,6) then
		--local iniy=pc.y
        --pc.y=
	--end
end

function animate()
	print("Change frame: "..pc.CF,0,18,6)
  	print("Change frame timer: "..pc.CF_timer,30,0,6)
	if pc.CF_timer == 0 then
		pc.changeFrame=true
		pc.CF=(pc.CF==1) and 2 or 1
		if pc.isIdle then pc.CF_timer=30
		elseif pc.isRun then pc.CF_timer=15
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

function draw()
	pcSpr_change()
	mvChar()
	resetPos()
	animate()
	spr(pc.spr_Id_h,pc.x,pc.y-8,pc.CLRK,pc.scale,pc.flip,0,2,1)
 	spr(pc.spr_Id_b,pc.x,pc.y,pc.CLRK,pc.scale,pc.flip,0,2,1)
	print("Frame: "..fr,0,130,6)
	fr=(fr+1)%60
	pc.CF_timer=pc.CF_timer-1	
end

-- end graphics
