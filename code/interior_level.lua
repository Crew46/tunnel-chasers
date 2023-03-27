-- title:  	tunnelchasers
-- author:  cordell/chimaezss
-- desc:    prototype sneaking
-- script:  lua

function interior_level_init()
	borderXMin = 10
	borderXMax = 228
	borderYMin = 10
	borderYMax = 116
	doorwayStart = borderXMax/2-20
	doorwayEnd = borderXMax/2+20
	moveDirection = 3
	sprLength = 13
	playerAni = 0
	sprHeight = 15
	waitTimer = 10
	officerAni = 233
	offTimer = 10
	offX = 90
	offY = 190
	trackOffX = offX
	trackOffY = offY
	offChase = 0
	offDirection = 3
	offResetX = 0
	offResetY = 0
	x=185
	y=-60
	trackX = 120-x

	function moveAnimation()
		if moveDirection ~= 0
		and moveDirection ~= 4 then
			if moveDirection == 2 then
				flip=1
			else flip=0 end
			if playerAni == 39 then
				if waitTimer < 0 then
					playerAni=playerAni-2
					waitTimer=10
				end
			elseif playerAni == 37 then
				if waitTimer < 0 then
					playerAni=playerAni+2
					waitTimer=10
				end
			else playerAni=37 end
		elseif moveDirection == 0 then -- move up
			if playerAni == 46 then
				if waitTimer < 0 then
					playerAni=playerAni-2
					waitTimer=10
				end
			elseif playerAni == 44 then
				if waitTimer < 0 then	
					playerAni=playerAni+2
					waitTimer=10
				end
			else playerAni=44 end
		else playerAni = 3 end
	end

	function officerFOV()
		if offFlip == 0 then
			if x <= offX+10
			and x > offX
			and y <= offY+10
			and y >= offY-10 then
				offChase=1
			elseif x <= offX+20
			and x > offX
			and y <= offY+15
			and y >= offY-15 then
				offChase=1
			elseif x <= offX+30
			and x > offX
			and y <= offY+20
			and y >= offY-20 then
				offChase=1
			elseif x <= offX+40
			and x > offX
			and y <= offY+30
			and y >= offY-30 then
				offChase=1
			elseif offChase == 1
			and (x >= offX+50
			or x < offX
			or y >= offY+30
			or y <= offY-30) then
				offChase=0
				offReset=1
			end
		elseif offFlip == 1 then
			if x >= offX-10
			and x < offX
			and y <= offY+10
			and y >= offY-10 then
				offChase=1
			elseif x >= offX-20
			and x < offX
			and y <= offY+15
			and y >= offY-15 then
				offChase=1
			elseif x >= offX-30
			and x < offX
			and y <= offY+20
			and y >= offY-20 then
				offChase=1
			elseif x >= offX-40
			and x < offX
			and y <= offY+30
			and y >= offY-30 then
				offChase=1
			elseif offChase == 1
			and (x <= offX-50
			or x >= offX+50
			or y >= offY+30
			or y <= offY-30) then
				offChase=0
				offReset=1
			end
		end -- first if statement
		if offResetY == 0
		and offChase == 1 then
			offResetY = offY
		end
		if offResetX == 0
		and offChase == 1 then
			offResetX = offX
		end
		if offChase == 1 -- ani change 
		and (officerAni == 236
		or officerAni == 238) then
			officerAni = 231
		end
		if x < offX -- flip when behind
		and offFlip == 1
		and offChase == 1 then
			offFlip = 0
		elseif x > offX
		and offFlip == 0
		and offChase == 1 then
			offFlip = 1
		end
	end

	function officer()
		offTimer=offTimer-1
		officerAni=454
		if officerAni == 454 then
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
				elseif offTimer == 0 then
					if trackOffX == 500 --moving down
					and trackOffY ~= 230 then
						offFlip=1
						offY=offY+1
						trackOffY=trackOffY+1
					elseif trackOffX ~= 500 --moving right
					and trackOffY == 190 then
						if officerAni == 236
						or officerAni == 238 then
							officerAni=231
						end
						offFlip=0
						offX=offX+1
						trackOffX=trackOffX+1
					elseif trackOffY == 230 --moving left
					and trackOffX ~= 90 then
						offX=offX-1
						trackOffX=trackOffX-1
					elseif trackOffX == 90 --moving up
					and trackOffY ~= 190 then
						if officerAni == 236 then
							officerAni=238
						elseif officerAni == 238 then
							officerAni=236
						end
						offFlip=0
						offY=offY-1
						trackOffY=trackOffY-1
					end
				end
			end
		end
		if officerAni == 454
		and offTimer == 0 then --ani control
			offTimer=10
		elseif officerAni == 454
		and offTimer == 0 then
			offTimer=10
		end
	end

	function simpleMovement()
		if btn(0) then
			y=y+1
			offY=offY+1
		elseif btn(1) then
			y=y-1
			offY=offY-1
		elseif btn(2) 
		and fget(mget(-(trackX//8)-3, (cameraY//8)+10), 0) == false then
			x=x+1
			trackX=trackX+1
			offX=offX+1
		elseif btn(3)
		and fget(mget(-(trackX//8)-2, (cameraY//8)+10), 0) == false then
			x=x-1
			trackX=trackX-1
			offX=offX-1
		end
	end
end

function interior_level_loop()
	cls(13)
	waitTimer=waitTimer-1
	offTimer=offTimer-1
	simpleMovement()
	moveAnimation()
	--officerFOV()
	--officer()
	cameraX = 120-x
	cameraY = 68-y
	camOffX = 120-offX
	camOffY = 68-offY
	map(cameraX//8, cameraY//8, 32, 18, -(cameraX%8), -(cameraY%8), -1)
	spr(264,109.5,68,0,1,flip,0,2,2)
	spr(454,offX,offY,0,1,offFlip,0,2,2)
	print((-trackX//8)-2, 84, 84) --for debugging
	print(trackOffX, 84, 100)
	print(trackOffY, 84, 120)
	-- Sprite Flag 0: 0, 83, 97-99, 113-117
end

make_system("interior_level", interior_level_init, interior_level_loop)

--end interior level
