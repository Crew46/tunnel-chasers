-- title:  	tunnelchasers
-- author:  cordell/chimaezss
-- desc:    prototype sneaking
-- script:  lua

function init()
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
	x=120
	y=60
	
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
		else playerAni = 3
		end
	end

end

function sneak_loop()
	playerMovement()
	cls(13)
	waitTimer=waitTimer-1
	roomBorder()
	moveAnimation()
	spr(playerAni,x,y,0,1,flip,0,2,2)
	print(moveDirection,84,84) --for debugging
end

make_system("sneak", init, tick)
