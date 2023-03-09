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
	offX = 15
	offY = 17
	offChase = 0
	offDirection = 3
	offResetX = 0
	offResetY = 0
	x=119
	y=180

	function roomBorder()
		line(borderXMin, borderYMin, borderXMax, borderYMin, 2) -- top
		line(borderXMin, borderYMin, borderXMin, borderYMax, 2) -- left side
		line(borderXMax, borderYMin, borderXMax, borderYMax, 2) -- right side
		line(borderXMin, borderYMax, doorwayStart, borderYMax, 2) -- bottom doorway side
		line(doorwayEnd, borderYMax, borderXMax, borderYMax, 2)
		line(doorwayStart, borderYMax, doorwayStart, 136, 2)
		line(doorwayEnd, borderYMax, doorwayEnd, 136, 2)
	end

	function playerMovement()
		moveDirection = 4
		if btn(0) and y ~= borderYMin then
			y=y-1
			moveDirection=0
		end
		if btn(1) 
		and (y ~= borderYMax-sprHeight
		or (x >= doorwayStart
		and x <= doorwayEnd-sprLength)) then
			y=y+1
			moveDirection=1
		end
		if btn(2) and x ~= borderXMin then
			if y > borderYMax - sprHeight then
				if x > doorwayStart then
					x=x-1
					moveDirection=2
				end
			else
				x=x-1
				moveDirection=2
			end
		end
		if btn(3) and x ~= borderXMax - sprLength then
			if y > borderYMax - sprHeight then
				if x < doorwayEnd - sprLength then
					x=x+1
					moveDirection=3
				end
			else
				x=x+1
				moveDirection=3
			end
		end
	end

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
		if officerAni == 231
		or officerAni == 233
		or officerAni == 236
		or officerAni == 238 then
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
					if offX == 203 --moving down
					and offY ~= 91 then
						offFlip=1
						offY=offY+2
					elseif offX ~= 203 --moving right
					and offY == 17 then
						if officerAni == 236
						or officerAni == 238 then
							officerAni=231
						end
						offFlip=0
						offX=offX+2
					elseif offY == 91 --moving left
					and offX ~= 17 then
						offX=offX-2
					elseif offX == 17 --moving up
					and offY ~= 17 then
						if officerAni == 236 then
							officerAni=238
							offTimer=10
						elseif officerAni == 238 then
							officerAni=236
							offTimer=10
						else 
							officerAni=236
							offTimer=10
						end
						offFlip=0
						offY=offY-2
					end
				end
			end
		end
		if officerAni == 231
		and offTimer == 0 then --ani control
			officerAni=233
			offTimer=10
		elseif officerAni == 233
		and offTimer == 0 then
			officerAni=231
			offTimer=10
		end
	end
end

function simpleMovement() -- for testing map function
	if btn(0) then
		y=y+.5
	elseif btn(1) then
		y=y-.5
	elseif btn(2) then
		x=x+.5
	elseif btn(3) then
		x=x-.5
	end
end

function interior_level_loop()
	cls(13)
	waitTimer=waitTimer-1
	offTimer=offTimer-1
	--roomBorder()
	--playerMovement()
	simpleMovement()
	moveAnimation()
	officerFOV()
	officer()
	cameraX = 120-x
	cameraY = 68-y
	map(cameraX-15, cameraY-8, 32, 17, (cameraX%8)-8, (cameraY%8)-8, 0)
	spr(playerAni,x+cameraX,y+cameraY,0,1,flip,0,2,2)
	--spr(playerAni,offX,offY,0,1,offFlip,0,2,2)
	print(x,84,84) --for debugging
end

make_system("interior_level", interior_level_init, interior_level_loop)
