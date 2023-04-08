function interior_level_init()
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
	offTimer = 15
	offX = 90
	offY = 190
	offFlip = 0
	trackOffX = offX
	trackOffY = offY
	offChase = 0
	offDirection = MOVE_RIGHT
	offResetX = 0
	offResetY = 0
	x=24
	y=28
	truePosX=185
	moveOffset=0

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
				if trackOffX == 500 --moving down
				and trackOffY ~= 230 then
					offDirection = MOVE_DOWN
					offFlip=1
					offY=offY+1
					trackOffY=trackOffY+1
				elseif trackOffX ~= 500 --moving right
				and trackOffY == 190 then
					offDirection = MOVE_RIGHT
					offFlip=0
					offX=offX+1
					trackOffX=trackOffX+1
				elseif trackOffY == 230 --moving left
				and trackOffX ~= 90 then
					offDirection = MOVE_LEFT
					offX=offX-1
					trackOffX=trackOffX-1
				elseif trackOffX == 90 --moving up
				and trackOffY ~= 190 then
					offDirection = MOVE_UP
					offFlip=0
					offY=offY-1
					trackOffY=trackOffY-1
				end
			end
		end
		officerAnimation()
		if offTimer <= 0 then -- timer reset
			offTimer = 15
		end
	end

	function playerMovement()
		if btn(MOVE_UP)
		and (fget(mget(x//8, y//8+19), 0) == false or
		fget(mget(x//8+2, y//8+19), 0) == false) then
			y=y-1
		elseif btn(MOVE_DOWN)
		and (fget(mget(x//8, y//8+21), 0) == false or
		fget(mget(x//8+2, y//8+21), 0) == false) then
			y=y+1
		elseif btn(MOVE_LEFT) 
		and (fget(mget(x//8, y//8+19), 0) == false or
		fget(mget(x//8, y//8+21), 0) == false) then
			x=x-1
		elseif btn(MOVE_RIGHT) 
		and (fget(mget(x//8+2, y//8+19), 0) == false or
		fget(mget(x//8+2, y//8+21), 0) == false) then
			x=x+1
		end
	end 
end

function interior_level_loop()
	cls(13)
	waitTimer=waitTimer-1
	offTimer=offTimer-1
	playerMovement()
 	--officerFOV()
	--officer()
	cameraX = 120-x
	cameraY = 64-y
	map(0, 17, 32, 18, 0, 0, -1)
	spr(playerAniHead,x,y+17,0,1,flip,0,2,1)
	spr(playerAniLegs,x,y+25,0,1,flip,0,2,1)
	spr(officerAniHead,offX,offY,0,1,offFlip,0,2,1)
	spr(officerAniLegs,offX,offY+8,0,1,offFlip,0,2,1)
	print(mget(x+1,y), 84, 84, 12) --for debugging
	print(x//8,84,100,12)
	print(y//8+19,84,120,12)
	-- Sprite Flag 0: 0, 83, 97-99, 113-117
end


make_system("interior_level", interior_level_init, interior_level_loop)

--end interior level
