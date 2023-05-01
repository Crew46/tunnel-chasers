-- Interior level


function interior_level_init()
	gsync(0,0,false)
	
	MOVE_UP = 0
	MOVE_DOWN = 1
	MOVE_LEFT = 2
	MOVE_RIGHT = 3
	NOT_MOVING = -1
	moveDirection = MOVE_RIGHT
	playerAniHead = 264
	playerAniLegs = 280
	officerAniHead = 454
	officerAniLegs = 470
	waitTimer = 15
	offTimer = 10
	offX = 90
	offY = 190
	offFlip = 0
	trackOffX = 20
	trackOffY = 90
	offChase = 0
	offDirection = MOVE_RIGHT
	offResetX = 0
	offResetY = 0
	x=24
	y=28
	cameraX=0
	cameraY=17
	roomInit=0
	cameraShift=0
	currentRoom=1
	previousRoom=1
	boost_time = 240

	--SM
	function interior_level_start()
		-- setting up player's collisionbox
		collisionBox.topY    = pc.y + 4
		collisionBox.bottomY = pc.y + 8
		collisionBox.leftX   = pc.x 
		collisionBox.rightX  = pc.x + 14
	end
	interior_level_start()
	--SM

	function officerAnimation()
		if offDirection == MOVE_UP and offTimer <= 0 then
			officerAniHead = 460
			if officerAniLegs == 492 then
				officerAniLegs = officerAniLegs + 16
			elseif playerAniLegs == 508 then
				officerAniLegs = officerAniLegs - 16
			else
				officerAniLegs = 492
			end
		elseif offDirection == MOVE_DOWN and offTimer <= 0 then
			officerAniHead = 454
			if officerAniLegs == 488 then
				officerAniLegs = officerAniLegs + 16
			elseif officerAniLegs == 504 then
				officerAniLegs = officerAniLegs - 16
			else
				officerAniLegs = 488
			end
		elseif offDirection == MOVE_LEFT and offTimer <= 0 then
			offFlip = 1
			officerAniHead = 454
			if officerAniLegs == 488 then
				officerAniLegs = officerAniLegs + 16
			elseif officerAniLegs == 504 then
				officerAniLegs = officerAniLegs - 16
			else
				officerAniLegs = 488
			end
		elseif offDirection == MOVE_RIGHT and offTimer <= 0 then
			offFlip = 0
			officerAniHead = 454
			if officerAniLegs == 488 then
				officerAniLegs = officerAniLegs + 16
			elseif officerAniLegs == 504 then
				officerAniLegs = officerAniLegs - 16
			else
				officerAniLegs = 488
			end
		elseif offTimer <= 0 then
			officerAniHead = 454
			officerAniLegs = 470
		end
	end

	function officerFOV()
		if offFlip == 0 then
			if mapPosX <= offMapX+3
			and mapPosX > offMapX
			and mapPosY <= offMapY+1
			and mapPosY >= offMapY-1 then
				offChase=1
			elseif mapPosX <= offMapX+5
			and mapPosX > offMapX
			and mapPosY <= offMapY+2
			and mapPosY >= offMapY-2 then
				offChase=1
			elseif mapPosX <= offMapX+6
			and mapPosX > offMapX
			and mapPosY <= offMapY+3
			and mapPosY >= offMapY-3 then
				offChase=1
			elseif mapPosX <= offMapX+8
			and mapPosX > offMapX
			and mapPosY <= offMapY+4
			and mapPosY >= offMapY-4 then
				offChase=1
			elseif offChase == 1
			and (mapPosX >= offMapX+8
			or mapPosY >= offMapY+5
			or mapPosY <= offMapY-5) then
				offChase=0
				offReset=1
			end
		elseif offFlip == 1 then
			if mapPosX >= offMapX-3
			and mapPosX < offMapX
			and mapPosY <= offMapY+1
			and mapPosY >= offMapY-1 then
				offChase=1
			elseif mapPosX >= offMapX-5
			and mapPosX < offMapX
			and mapPosY <= offMapY+2
			and mapPosY >= offMapY-2 then
				offChase=1
			elseif mapPosX >= offMapX-6
			and mapPosX < offMapX
			and mapPosY <= offMapY+3
			and mapPosY >= offMapY-3 then
				offChase=1
			elseif mapPosX >= offMapX-8
			and mapPosX < offMapX
			and mapPosY <= offMapY+4
			and mapPosY >= offMapY-4 then
				offChase=1
			elseif offChase == 1
			and (mapPosX <= offMapX-8
			or mapPosY >= offMapY+5
			or mapPosY <= offMapY-5) then
				offChase=0
				offReset=1
			end
		end -- first if statement
		if offResetY == 0
		and offChase == 1 then
			offResetY = offMapY
		end
		if offResetX == 0
		and offChase == 1 then
			offResetX = offMapX
		end
		if mapPosX < offMapX -- flip when behind
		and offFlip == 1
		and offChase == 1 then
			offFlip = 1
		elseif mapPosX > offMapX
		and offFlip == 0
		and offChase == 1 then
			offFlip = 0
		end
	end

	function officer()
		if offChase == 1 and offReset ~= 1 then -- chase control
			if offMapX == mapPosX
			and offMapY == mapPosY then
				offChase=0
				offReset=1
				player.flip=0
  				player.isTurned=false
  				player.isIdle=true
				player.changeFrame=true
				animate_chr()
				current_system="discussion"
			elseif offMapX > mapPosX then
				offFlip=1
				offX=offX-.5
				offMapX=offMapX-1/16
			elseif offMapX < mapPosX then
				offFlip=0
				offX=offX+.5
				offMapX=offMapX+1/16
			elseif offMapY > mapPosY then
				offY=offY-.5
				offMapY=offMapY-1/16
			elseif offMapY < mapPosY then
				offY=offY+.5
				offMapY=offMapY+1/16
			end
		else
			if offReset == 1 then -- officer reset to position before chase
				if offMapX < offResetX then
					offX=offX+.5
					offMapX=offMapX+1/16
					offFlip=0
				elseif offMapX > offResetX then
					offX=offX-.5
					offMapX=offMapX-1/16
					offFlip=1
				elseif offMapY < offResetY then
					offY=offY+.5
					offMapY=offMapY+1/16
				elseif offMapY > offResetY then
					offY=offY-.5
					offMapY=offMapY-1/16
				elseif offMapX == offResetX
				and offMapY == offResetY then
					offReset=0
					offResetX = 0
					offResetY = 0
				end
			elseif offTimer <= 0 then
				if offMapX == 55 --moving up
				and offMapY ~= 40.5 then
					offDirection = MOVE_UP
					offFlip=1
					offY=offY-1
					offMapY=offMapY-1/8
				elseif offMapX ~= 55 --moving right
				and offMapY == 45.5 then
					offDirection = MOVE_RIGHT
					offFlip=0
					offX=offX+1
					offMapX=offMapX+1/8
				elseif offMapX ~= 3 --moving left
				and offMapY == 40.5 then
					offDirection = MOVE_LEFT
					offX=offX-1
					offMapX=offMapX-1/8
				elseif offMapX == 3 --moving down
				and offMapY ~= 45.5 then
					offDirection = MOVE_DOWN
					offFlip=0
					offY=offY+1
					offMapY=offMapY+1/8
				end
			end
		end
		officerAnimation()
		if offTimer <= 0 then -- timer reset
			offTimer = 10
		end
	end

	function playerMovement()
		if btn(MOVE_UP)
		and (fget(mget(math.floor(mapPosX-.5), math.floor(mapPosY-.5)), 0) == false or
		fget(mget(math.floor(mapPosX+.5), math.floor(mapPosY-.5)), 0) == false) then
			y=y-1
			mapPosY=mapPosY-1/8
			moveDirection=MOVE_UP
		elseif btn(MOVE_DOWN)
		and (fget(mget(math.floor(mapPosX-.5), math.floor(mapPosY+1.5)), 0) == false or
		fget(mget(math.floor(mapPosX+.5), math.floor(mapPosY+1.5)), 0) == false) then
			y=y+1
			mapPosY=mapPosY+1/8
			moveDirection=MOVE_DOWN
		elseif btn(MOVE_LEFT) 
		and (fget(mget(math.floor(mapPosX-.5), math.floor(mapPosY-.5)), 0) == false or
		fget(mget(math.floor(mapPosX-.5), math.floor(mapPosY+1.5)), 0) == false) then
			x=x-1
			mapPosX=mapPosX-1/8
			moveDirection=MOVE_LEFT
		elseif btn(MOVE_RIGHT) 
		and (fget(mget(math.floor(mapPosX+.5), math.floor(mapPosY-.5)), 0) == false or
		fget(mget(math.floor(mapPosX+.5), math.floor(mapPosY+1.5)), 0) == false) then
			x=x+1
			mapPosX=mapPosX+1/8
			moveDirection=MOVE_RIGHT
		else moveDirection=NOT_MOVING end
	end

	function roomOne()
		if roomInit == 0 then
			x=24
			y=44
			cameraX=0
			cameraY=17
			mapPosX=4
			mapPosY=23
			roomInit=-1
		elseif roomInit == 1 then
			x=184
			y=114
			cameraX=0
			cameraY=17
			mapPosX=24
			mapPosY=31.75
			roomInit=-1
		-- SM
		elseif roomInit == 2 then
			x=27*8
			y=8*8
			cameraX=0
			cameraY=17
			mapPosX=28
			mapPosY=25.5
			roomInit=-1
		-- SM
		end
	end

	function roomTwo()
		if roomInit ~= -1 then -- Constant changes for all or most scenarios
			offMapX=3
			offMapY=45.5
			cameraY=34
		end
		if roomInit == 0 then
			mapPosX=23.5
			mapPosY=40
			x=182
			y=60
			offX=20
			offY=90
		elseif roomInit == 1 then
			x=201
			y=60
			cameraShift=1
			mapPosX=52.5
			mapPosY=39.75
			offX=-220
			offY=90
		elseif roomInit == 2 then -- Overworld Entrance Left
			mapPosX = 7.875
			mapPosY = 46.5
			x = 57
			y = 112
			offX=20
			offY=90
		elseif roomInit == 3 then -- Overworld Entrance Middle
			mapPosX = 29
			mapPosY = 46.5
			x = 226
			y = 112
			offX=20
			offY=90
		elseif roomInit == 4 then -- Overworld Entrance Right
			mapPosX = 52.5
			mapPosY = 46.375
			x = 199
			y = 111
			cameraShift=1
			offX=-220
			offY=90
		end
		roomInit=-1
		if mapPosX > 30 then
			cameraX=30
			if cameraShift == 0 then
				x=x-215
				offX=offX-240
			end
			cameraShift=1
		elseif mapPosX <= 30 and cameraShift == 1 then
			cameraX=0
			cameraShift=0
			x=x+215
			offX=offX+240
		end
	end

	function roomThree()
		if roomInit == 0 then
			x=173
			y=236
			cameraX=35
			cameraY=17
			mapPosX=53
			mapPosY=32
			roomInit=1
		end
		if mapPosY <= 17 then
			cameraY=0
			if cameraShift == 0 then y=y+120 end
			cameraShift=1
		elseif mapPosY >= 17 then
			cameraY=17
			if cameraShift == 1 then y=y-120 end
			cameraShift=0
		end
	end

	function roomControl()
		if currentRoom == 1 then -- Room 1
			roomOne()
			if mapPosY >= 32
			and (mapPosX >= 23 and mapPosX <= 25) then
				if btnp(4) then
					previousRoom = 1
					currentRoom = 2
					roomInit=0
					roomTwo()
				end
			end
		elseif currentRoom == 2 then 
			roomTwo()
			officer()
			officerFOV()
			if mapPosY <= 39.375 -- Room 2 back to Room 1
			and (mapPosX >= 23.0 and mapPosX <= 24.5) then
				if btnp(4) then
					previousRoom = 2
					currentRoom = 1
					roomInit = 1
					roomOne()
				end
			elseif mapPosY <= 39.375 -- Room 2 to Room 3
			and (mapPosX >= 52.5 and mapPosX <= 54.0) then
				if btnp(4) then
					previousRoom = 2
					currentRoom = 3
					roomInit = 0
					roomThree()
				end
			end
		elseif currentRoom == 3 then -- Room 3 back to Room 2
			roomThree()
			if mapPosY >= 31.5
			and (mapPosX >= 52 and mapPosX <= 53.5) then
				if btnp(4) then
					previousRoom = 3
					currentRoom = 2
					roomInit = 1
					roomTwo()
				end
			end
		end
	end

end

function interior_level_loop()
	-- SM
	if info_pass ~= nil then
		if     info_pass == "side1" then
			if roomInit ~= -1 then roomInit = 2 end
			currentRoom=1
		elseif info_pass == "side2" then
			currentRoom=3
		elseif info_pass == "left"  then
			currentRoom=2
			if roomInit ~= -1 then roomInit = 2 end
		elseif info_pass == "main"  then
			currentRoom=2
			if roomInit ~= -1 then roomInit = 3 end
		elseif info_pass == "right" then
			currentRoom=2
			if roomInit ~= -1 then roomInit = 4 end
		end
		info_pass = nil
	else
		if currentRoom == 1 and x == 212 and y == 62 then
			info_pass = "side1"
			current_system = "overworld_system"
		end
		if currentRoom == 2 then
			if mapPosY == 48.5 then
				if mapPosX >= 6 and mapPosX <= 10 then
					info_pass = "left"
					current_system = "overworld_system"
				elseif mapPosX >= 28 and mapPosX <= 32 then
					info_pass = "main"
					current_system = "overworld_system"
				elseif mapPosX >= 51 and mapPosX <= 54 then
					info_pass = "right"
					current_system = "overworld_system"
				end
			end
		end
	end
	-- SM

	cls(13)
	waitTimer=waitTimer-1
	offTimer=offTimer-1
	--pcActions()
	--animate()
	playerMovement()
	roomControl()
	map(cameraX, cameraY, 32, 18, 0, 0, -1)--foreground
	map(cameraX+60,cameraY,32,18,0,0,0)--decorations
	gsync(2,1,false)
	spr(player.spr_Id_h,x-cameraX,y-cameraY+17,player.CLRK,player.scale,player.flip,0,2,1)
	spr(player.spr_Id_b,x-cameraX,y-cameraY+25,player.CLRK,player.scale,player.flip,0,2,1)
	--SM
	collisionBox.screenMap.x = cameraX*8
	collisionBox.screenMap.y = cameraY*8
	interior_level_start()
	drawpc()
	rectb(collisionBox.leftX,  collisionBox.topY,    1, 1, 1)
	rectb(collisionBox.rightX, collisionBox.topY,    1, 1, 1)
	rectb(collisionBox.leftX,  collisionBox.bottomY, 1, 1, 1)
	rectb(collisionBox.rightX, collisionBox.bottomY, 1, 1, 1)
	--SM
	gsync(2,0,false)
	spr(officerAniHead,offX,offY,0,1,offFlip,0,2,1)
	spr(officerAniLegs,offX,offY+8,0,1,offFlip,0,2,1)
	map(cameraX+120,cameraY,32,18,0,0,0)--overlay
	-- stuff below for debugging
	print(mapPosX,84,84,12)
	print(mapPosY,84,100,12)
	print((x).." "..(y),84,120,12)
	print("Head: "..player.spr_Id_h,0,6,6)
  	print("Body: "..player.spr_Id_b,60,6,6)
	print("Selected char: "..player.selected,0,12,6)
	--SM
	if keyp(24) then
		current_system = "overworld_system"
	end
	--SM
	-- Sprite Flag 0: 0, 83, 97-99, 113-117


	--DM
	draw_inv(player.inventory)
	boost_time = check_boost(boost_time)
	if keyp(54) then
		cycle_inv(player.inventory)	
	end
	if keyp(55) then
		use_item(player.inventory)
	end
	if keyp(56) then
		add_item(5)
		add_item(7)
		add_item(1)
		add_item(3)
	end
	vbank(0)


end

make_system("interior_level", interior_level_init, interior_level_loop)

--end interior level
