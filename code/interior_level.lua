-- Interior level

function interior_level_init()
	sync(0,0,false)

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

	function playerAnimation()
		if moveDirection == MOVE_UP and waitTimer <= 0 then
			playerAniHead = 268
			if playerAniLegs == 300 then
				playerAniLegs = playerAniLegs + 16
			elseif playerAniLegs == 316 then
				playerAniLegs = playerAniLegs - 16
			else
				playerAniLegs = 300
			end
		elseif moveDirection == MOVE_DOWN and waitTimer <= 0 then
			playerAniHead = 264
			if playerAniLegs == 296 then
				playerAniLegs = playerAniLegs + 16
			elseif playerAniLegs == 312 then
				playerAniLegs = playerAniLegs - 16
			else
				playerAniLegs = 296
			end
		elseif moveDirection == MOVE_LEFT and waitTimer <= 0 then
			flip = 1
			playerAniHead = 264
			if playerAniLegs == 296 then
				playerAniLegs = playerAniLegs + 16
			elseif playerAniLegs == 312 then
				playerAniLegs = playerAniLegs - 16
			else
				playerAniLegs = 296
			end
		elseif moveDirection == MOVE_RIGHT and waitTimer <= 0 then
			flip = 0
			playerAniHead = 264
			if playerAniLegs == 296 then
				playerAniLegs = playerAniLegs + 16
			elseif playerAniLegs == 312 then
				playerAniLegs = playerAniLegs - 16
			else
				playerAniLegs = 296
			end
		elseif waitTimer <= 0 then
			playerAniHead = 264
			playerAniLegs = 280
		end
		if waitTimer <= 0 then
			waitTimer = 15
		end
	end
	
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
		trackPlayerX = x - 95 -- x - 95 for offX | x - 115 for trackOffX
		trackPlayerY = -y - 114 -- -y - 114 for offY | -y + 8 for trackOffY
		if offFlip == 0 then
			if trackPlayerX <= trackOffX+10
			and trackPlayerX > trackOffX
			and trackPlayerY <= trackOffY+10
			and trackPlayerY >= trackOffY-10 then
				offChase=1
			elseif trackPlayerX <= trackOffX+20
			and trackPlayerX > trackOffX
			and trackPlayerY <= trackOffY+15
			and trackPlayerY >= trackOffY-15 then
				offChase=1
			elseif trackPlayerX <= trackOffX+30
			and trackPlayerX > trackOffX
			and trackPlayerY <= trackOffY+20
			and trackPlayerY >= trackOffY-20 then
				offChase=1
			elseif trackPlayerX <= trackOffX+40
			and trackPlayerX > trackOffX
			and trackPlayerY <= trackOffY+30
			and trackPlayerY >= trackOffY-30 then
				offChase=1
			elseif offChase == 1
			and (trackPlayerX >= trackOffX+50
			or trackPlayerX < trackOffX
			or trackPlayerY >= trackOffY+30
			or trackPlayerY <= trackOffY-30) then
				offChase=0
				offReset=1
			end
		elseif offFlip == 1 then
			if trackPlayerX >= trackOffX-10
			and trackPlayerX < trackOffX
			and trackPlayerY <= trackOffY+10
			and trackPlayerY >= trackOffY-10 then
				offChase=1
			elseif trackPlayerX >= trackOffX-20
			and trackPlayerX < trackOffX
			and trackPlayerY <= trackOffY+15
			and trackPlayerY >= trackOffY-15 then
				offChase=1
			elseif trackPlayerX >= trackOffX-30
			and trackPlayerX < trackOffX
			and trackPlayerY <= trackOffY+20
			and trackPlayerY >= trackOffY-20 then
				offChase=1
			elseif trackPlayerX >= trackOffX-40
			and trackPlayerX < trackOffX
			and trackPlayerY <= trackOffY+30
			and trackPlayerY >= trackOffY-30 then
				offChase=1
			elseif offChase == 1
			and (trackPlayerX <= trackOffX-50
			or trackPlayerX >= trackOffX+50
			or trackPlayerY >= trackOffY+30
			or trackPlayerY <= trackOffY-30) then
				offChase=0
				offReset=1
			end
		end -- first if statement
		if offResetY == 0
		and offChase == 1 then
			offResetY = trackOffY
		end
		if offResetX == 0
		and offChase == 1 then
			offResetX = trackOffX
		end
		if trackPlayerX < trackOffX -- flip when behind
		and offFlip == 1
		and offChase == 1 then
			offFlip = 0
		elseif trackPlayerX > trackOffX
		and offFlip == 0
		and offChase == 1 then
			offFlip = 1
		end
	end

	function officer()
		if offChase == 1 then -- chase control
			if offX == x
			and offY == y then
				offChase=0
				offReset=1
			elseif offX > x then
				offFlip=1
				offX=offX-1
			elseif offX < x then
				offFlip=0
				offX=offX+1
			elseif offY > y then
				offY=offY-1
			elseif offY < y then
				offY=offY+1
			end
		else
			if offReset == 1 then -- officer reset to position before chase
				if offX < offResetX then
					offX=offX+1
					offFlip=0
				elseif offX > offResetX then
					offX=offX-1
					offFlip=1
				elseif offY < offResetY then
					offY=offY+1
				elseif offY > offResetY then
					offY=offY-1
				elseif offX == offResetX
				and offY == offResetY then
					offReset=0
					offResetX = 0
					offResetY = 0
				end
			elseif offTimer <= 0 then
				if trackOffX == 455 --moving up
				and trackOffY ~= 45 then
					offDirection = MOVE_UP
					offFlip=1
					offY=offY-1
					trackOffY=trackOffY-1
				elseif trackOffX ~= 455 --moving right
				and trackOffY == 90 then
					offDirection = MOVE_RIGHT
					offFlip=0
					offX=offX+1
					trackOffX=trackOffX+1
				elseif trackOffX ~= 20 --moving left
				and trackOffY == 45 then
					offDirection = MOVE_LEFT
					offX=offX-1
					trackOffX=trackOffX-1
				elseif trackOffX == 20 --moving down
				and trackOffY ~= 90 then
					offDirection = MOVE_DOWN
					offFlip=0
					offY=offY+1
					trackOffY=trackOffY+1
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
		playerAnimation()
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
		end
	end

	function roomTwo()
		if roomInit == 0 then
			mapPosX=23.5
			mapPosY=40
			cameraY=34
			x=182
			y=60
			offX=20
			offY=90
		elseif roomInit == 1 then
			x=201
			y=60
			cameraY=34
			cameraShift=1
			mapPosX=52.5
			mapPosY=39.75
			offX=20
			offY=90
		end
		roomInit=-1
		if mapPosX >= 30 then
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
		if currentRoom == 1 then -- Room 1 to Room 2
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
		elseif currentRoom == 2 then -- Room 2 back to Room 1
			roomTwo()
			officer()
			if mapPosY <= 39.375
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
	cls(13)
	waitTimer=waitTimer-1
	offTimer=offTimer-1
	playerMovement()
 	--officerFOV()
	roomControl()
	map(cameraX, cameraY, 32, 18, 0, 0, -1)
	spr(playerAniHead,x-cameraX,y-cameraY+17,0,1,flip,0,2,1)
	spr(playerAniLegs,x-cameraX,y-cameraY+25,0,1,flip,0,2,1)
	spr(officerAniHead,offX,offY,0,1,offFlip,0,2,1)
	spr(officerAniLegs,offX,offY+8,0,1,offFlip,0,2,1)
	print(trackOffX, 84, 84, 12) --for debugging
	print(trackOffY,84,100,12)
	print(x//8,84,120,12)
	-- Sprite Flag 0: 0, 83, 97-99, 113-117
end

make_system("interior_level", interior_level_init, interior_level_loop)

--end interior level
