---
--- Created by AshBC.
--- DateTime: 03/25/23 10:00 AM
--- graphics library

fr=0
--bttn={u=0,d=1,l=2,r=3,z=4,x=5,a=6,s=7}
bttn={u=0,d=1,l=2,r=3,w=23,s=19,a=1,d=4,q=17,e=5,z=26,x=24}

pc={x=240/2,y=136/2,sprId=256,CLRK=0,scale=1,flip=0,
	indx=1,changeFrame=false,CF=1,
	wait=30,isIdle=true,isRun=false,
	name={"pig","nul","par","byz"},selected="pig",
 iniSpr={256,288,320,352},
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
	if keyp(bttn.q,60,15) then 
		pc.indx=(pc.indx>1) and pc.indx-1 or 1
		pc.selected=pc.name[pc.indx]
		pc.sprId=pc.iniSpr[pc.indx]
	elseif keyp(bttn.e,60,15) then 
		pc.indx=(pc.indx<=3)and pc.indx+1 or 4
		pc.selected=pc.name[pc.indx]
		pc.sprId=pc.iniSpr[pc.indx]
	end
	print(pc.sprId,0,6,12)
	print("Selected char: "..pc.selected,0,12,12)
end

function resetPos()
	if keyp(bttn.z,60,15) then
		pc.x=70
		pc.y=75
	end
end

function mvChar()
	local hold=3
 local period=1
	if keyp(bttn.w,hold,period) then
		pc.y=pc.y-.5
	elseif keyp(bttn.s,hold,period) then
		pc.y=pc.y+.5
	else 
		pc.isIdle=true
		pc.isRun=false
	end
	if keyp(bttn.a,hold,period) then 
		pc.x=pc.x-.5
		pc.flip=1
	elseif keyp(bttn.d,hold,period) then 
		pc.x=pc.x+.5
		pc.flip=0
	else 
		pc.isIdle=true
		pc.isRun=false
	end
	if keyp(bttn.w,hold,period) or keyp(bttn.s,hold,period) or keyp(bttn.a,hold,period) or keyp(bttn.d,hold,period) then
		pc.isIdle=false
		pc.isRun=true
		pc.changeFrame=true
	end
	--if keyp(bttn.x,60,6) then
		--local iniy=pc.y
        --pc.y=
	--end
end

function animate()
	print("Change frame: "..pc.CF,0,18,12)
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
		pc.sprId=pc.sprites[pc.indx][pc.CF+2]
		pc.changeFrame=false
	end
end

function draw()
	
	pcSpr()
	mvChar()
	resetPos()
	animate()
	spr(pc.sprId,pc.x,pc.y,pc.CLRK,pc.scale,pc.flip,0,2,2)
	print("Frame: "..fr,0,130,12)
	fr=(fr+1)%60
	pc.wait=pc.wait-1
		
end

-- end graphics
