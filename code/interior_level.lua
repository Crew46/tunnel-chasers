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
	npc_anim(328,330,0,0,1)

	--SM
	function interior_level_collisionbox_update()
		-- setting up player's collisionbox
		collisionBox.topY    = player.y + 4
		collisionBox.bottomY = player.y + 7
		collisionBox.leftX   = player.x + 3
		collisionBox.rightX  = player.x + 12
	end
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
			player.x=24
			player.y=44
			cameraX=0
			cameraY=17
			mapPosX=4
			mapPosY=23
		elseif roomInit == 1 then
			player.x=184
			player.y=114
			cameraX=0
			cameraY=17
			mapPosX=24
			mapPosY=31.75
		elseif roomInit == 2 then
			player.x=27*8
			player.y=8*8
			cameraX=0
			cameraY=17
			mapPosX=28
			mapPosY=25.5
		end
		roomInit=-1
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
			player.x=182
			player.y=60
			offX=20
			offY=90
		elseif roomInit == 1 then
			player.x=201
			player.y=60
			cameraShift=1
			mapPosX=52.5
			mapPosY=39.75
			offX=-220
			offY=90
		elseif roomInit == 2 then -- Overworld Entrance Left
			mapPosX = 7.875
			mapPosY = 46.5
			player.x = 57
			player.y = 112
			offMapX=12
			offX=90
			offY=90
		elseif roomInit == 3 then -- Overworld Entrance Middle
			mapPosX = 29
			mapPosY = 46.5
			player.x = 226
			player.y = 112
			offX=20
			offY=90
		elseif roomInit == 4 then -- Overworld Entrance Right
			mapPosX = 52.5
			mapPosY = 46.375
			player.x = 199
			player.y = 111
			cameraShift=1
			offX=-220
			offY=90
		end
		roomInit=-1
		if mapPosX > 30 then
			cameraX=30
			if cameraShift == 0 then
				player.x=player.x-215
				offX=offX-240
			end
			cameraShift=1
		elseif mapPosX <= 30 and cameraShift == 1 then
			cameraX=0
			cameraShift=0
			player.x=player.x+215
			offX=offX+240
		end
	end

	function roomThree()
		if roomInit == 0 then
			player.x=173
			player.y=236
			cameraX=35
			cameraY=17
			mapPosX=53
			mapPosY=32
		elseif roomInit == 1 then
			mapPosX = 42.5
			mapPosY = 26.25
			cameraX = 35
			cameraY = 17
			player.x = 87
			player.y = 70
		end
		roomInit = -1
		if mapPosY <= 17 then
			cameraY=0
			if cameraShift == 0 then player.y=player.y+120 end
			cameraShift=1
		elseif mapPosY >= 17 then
			cameraY=17
			if cameraShift == 1 then player.y=player.y-120 end
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
			if mapPosY <= 39.375
			and (mapPosX >= 23.0 and mapPosX <= 24.5) then
				if btnp(4) and offChase == 0 then
					previousRoom = 2
					currentRoom = 1
					roomInit = 1
					roomOne()
				end
			elseif mapPosY <= 39.375
			and (mapPosX >= 52.5 and mapPosX <= 54.0) then
				if btnp(4) and offChase == 0 then
					previousRoom = 2
					currentRoom = 3
					roomInit = 0
					roomThree()
				end
			end
		elseif currentRoom == 3 then
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

	-- SM
	hideableTilePosition = {
		x = -1,
		y = -1
	}
	preHidingPosition = {
		sprX = -1,
		sprY = -1,
		mapX = -1,
		mapY = -1
	}
	hideableTile = -1
	function check_hiding_spot()
		-- adding this to the position of a point makes it
		-- it's location in decoration overlay
		local decorationOverlayOffset = 480
		-- determines whether hiding above is possible
		local isAboveHidable = collisionbox_flagcheck(2, 1, {wallCheck = decorationOverlayOffset - 4, roofCheck = 4})
		-- position of potentially hidable tile
		local aboveHidablePosition = collisionbox_positioncheck(1, {wallCheck = decorationOverlayOffset - 4, roofCheck = 4})
		-- did player just trigger hiding action in function
		local justHid = false

		-- if player can hide and they are not
		-- hiding, provide them the option to hide
		if isAboveHidable and not player.isHidden then
			-- only David can hide in lockers
			if player.indx ~= 3 and mget(aboveHidablePosition[1]/8, aboveHidablePosition[2]/8) == 214 then
				return
			end

			print("z to hide!", player.x + 10, player.y - 15, 4)
			if keyp(26) then
				justHid = true
				player.isHidden = true
			end
		end

		if justHid then
			hideableTilePosition.x = aboveHidablePosition[1]
			hideableTilePosition.y = aboveHidablePosition[2]
			preHidingPosition.sprX = player.x
			preHidingPosition.sprY = player.y
			preHidingPosition.mapX = mapPosX
			preHidingPosition.mapY = mapPosY
			hideableTile = mget(hideableTilePosition.x/8, hideableTilePosition.y/8)

			if     hideableTile == 214 then
				mset(hideableTilePosition.x/8, (hideableTilePosition.y - 8)/8, 197)
			elseif hideableTile == 252 then
				mset(hideableTilePosition.x/8, (hideableTilePosition.y - 8)/8, 235)
			elseif hideableTile == 250 then
				mset(hideableTilePosition.x/8, (hideableTilePosition.y - 8)/8, 251) 
			elseif hideableTile == 247 then
				mset(hideableTilePosition.x/8,     hideableTilePosition.y/8, 227)
				mset((hideableTilePosition.x-8)/8, hideableTilePosition.y/8, 226)
			elseif hideableTile == 246 then
				mset((hideableTilePosition.x+8)/8, hideableTilePosition.y/8, 227)
				mset(hideableTilePosition.x/8,     hideableTilePosition.y/8, 226)
			elseif hideableTile == 245 then
				mset(hideableTilePosition.x/8,     hideableTilePosition.y/8, 243)
				mset((hideableTilePosition.x-8)/8, hideableTilePosition.y/8, 242)
			elseif hideableTile == 244 then
				mset((hideableTilePosition.x+8)/8, hideableTilePosition.y/8, 244)
				mset(hideableTilePosition.x/8,     hideableTilePosition.y/8, 242)
			end

			if offChase == 1 then
				offReset = 1
			end
		elseif keyp(26) and player.isHidden then
			if hideableTile == 214 then
				mset(hideableTilePosition.x/8, (hideableTilePosition.y - 8)/8, 198)
			elseif hideableTile == 252 then
				mset(hideableTilePosition.x/8, (hideableTilePosition.y - 8)/8, 236)
			elseif hideableTile == 250 then
				mset(hideableTilePosition.x/8, (hideableTilePosition.y - 8)/8, 234) 
			elseif hideableTile == 247 then
				mset(hideableTilePosition.x/8,     hideableTilePosition.y/8, 247)
				mset((hideableTilePosition.x-8)/8, hideableTilePosition.y/8, 246)
			elseif hideableTile == 246 then
				mset((hideableTilePosition.x+8)/8, hideableTilePosition.y/8, 247)
				mset(hideableTilePosition.x/8,     hideableTilePosition.y/8, 246)
			elseif hideableTile == 245 then
				mset(hideableTilePosition.x/8,     hideableTilePosition.y/8, 245)
				mset((hideableTilePosition.x-8)/8, hideableTilePosition.y/8, 244)
			elseif hideableTile == 244 then
				mset((hideableTilePosition.x+8)/8, hideableTilePosition.y/8, 245)
				mset(hideableTilePosition.x/8,     hideableTilePosition.y/8, 244)
			end
			player.isHidden = false
			player.x = preHidingPosition.sprX
			player.y = preHidingPosition.sprY
			mapPosX  = preHidingPosition.mapX
			mapPosY  = preHidingPosition.mapY

			hideableTilePosition.x = -1
			hideableTilePosition.y = -1
			preHidingPosition.sprX = -1
			preHidingPosition.sprY = -1
			preHidingPosition.mapX = -1
			preHidingPosition.mapY = -1
			hideableTile = -1
		end
	end
	-- SM
end

function interior_level_loop()
	-- SM
	if info_pass ~= nil then
		if     info_pass == "side1" then
			if roomInit ~= -1 then roomInit = 2 end
			currentRoom=1
		elseif info_pass == "side2" then
			currentRoom=3
			if roomInit ~= -1 then roomInit = 1 end
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
	--playerMovement()
	roomControl()
	map(cameraX, cameraY, 32, 18, 0, 0, -1)--foreground
	map(cameraX+60,cameraY,32,18,0,0,0)--decorations

	if currentRoom==1 then npc_anim(328,330,108,35,1) end --wedge

	gsync(2,1,false)
	--spr(player.spr_Id_h,x-cameraX,y-cameraY+17,player.CLRK,player.scale,player.flip,0,2,1)
	--spr(player.spr_Id_b,x-cameraX,y-cameraY+25,player.CLRK,player.scale,player.flip,0,2,1)

	--SM
	collisionBox.screenMap.x = cameraX*8
	collisionBox.screenMap.y = cameraY*8
	interior_level_collisionbox_update()
	check_hiding_spot()
	if not player.isHidden then
		drawpc()
		x = math.floor(player.x)
		y = math.floor(player.y - 8)
		mapPosX = cameraX + (x/8)
		mapPosY = cameraY + ((y+8)/8)
	end
	rectb(collisionBox.leftX,  collisionBox.topY,    1, 1, 1)
	rectb(collisionBox.rightX, collisionBox.topY,    1, 1, 1)
	rectb(collisionBox.leftX,  collisionBox.bottomY, 1, 1, 1)
	rectb(collisionBox.rightX, collisionBox.bottomY, 1, 1, 1)
	--SM

	gsync(2,0,false)
	spr(officerAniHead,offX,offY,0,1,offFlip,0,2,1)
	spr(officerAniLegs,offX,offY+8,0,1,offFlip,0,2,1)
	map(cameraX+120,cameraY,32,18,0,0,0)--overlay
	if currentRoom == 3 then rect(200, 32, 40, 120, 0) end--fix visual problems room 3

	-- debugging
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
	-- debugging

	-- Sprite Flag 0: 0, 83, 97-99, 113-117

	--DM
	draw_inv(player.inventory)
	check_boosts(active_boosts)
	if keyp(54) then
		cycle_inv(player.inventory)	
	end
	if keyp(55) then
		use_item(player.inventory)
	end
	if keyp(56) then
		-- item_to_inv(5)
		item_to_inv(7)
		-- item_to_inv(1)
		-- item_to_inv(3)
	end
	vbank(0)
	--DM
end

make_system("interior_level", interior_level_init, interior_level_loop)

--end interior level
