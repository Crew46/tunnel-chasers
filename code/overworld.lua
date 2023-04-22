-- title:  overworld
-- author: Saqib Malik
-- desc:   TunnelRunners overworld prototyping TIC.

function overworld_system_init()
    gsync( 1|2|4|64,3,false)
	collisionBox = {
		screenMap = {
			x = 0,
			y = 0
		},

		topY    = 0,
		bottomY = 0,
		leftX   = 0,
		rightX  = 0
	}
	function collisionbox_positioncheck(point, sweep)
		sweep = sweep or { }
		absoluteX = collisionBox.screenMap.x
		absoluteY = collisionBox.screenMap.y
		if     point == 0 then
			absoluteX = absoluteX + collisionBox.leftX
			absoluteY = absoluteY + collisionBox.topY
			if sweep.wallCheck then
				absoluteX = absoluteX - sweep.wallCheck
			end
			if sweep.roofCheck then
				absoluteY = absoluteY - sweep.roofCheck
			end
		elseif point == 1 then
			absoluteX = absoluteX + collisionBox.rightX
			absoluteY = absoluteY + collisionBox.topY
			if sweep.wallCheck then
				absoluteX = absoluteX + sweep.wallCheck
			end
			if sweep.roofCheck then
				absoluteY = absoluteY - sweep.roofCheck
			end
		elseif point == 2 then
			absoluteX = absoluteX + collisionBox.leftX
			absoluteY = absoluteY + collisionBox.bottomY
			if sweep.wallCheck then
				absoluteX = absoluteX - sweep.wallCheck
			end
			if sweep.roofCheck then
				absoluteY = absoluteY + sweep.roofCheck
			end
		elseif point == 3 then
			absoluteX = absoluteX + collisionBox.rightX
			absoluteY = absoluteY + collisionBox.bottomY
			if sweep.wallCheck then
				absoluteX = absoluteX + sweep.wallCheck
			end
			if sweep.roofCheck then
				absoluteY = absoluteY + sweep.roofCheck
			end
		else
			error("Collisionbox point out-of-bounds.", 2)
		end

		return {absoluteX, absoluteY}
	end
	function collisionbox_tilecheck(point, sweep)
		absolutePositions = collisionbox_positioncheck(point, sweep)
		return mget(absolutePositions[1]/8, absolutePositions[2]/8)
	end
	function collisionbox_flagcheck(flag, point, sweep)
		tile = collisionbox_tilecheck(point, sweep)
		return fget(tile, flag)
	end
	function collisionbox_flagchecks(flag, points, sweep)
		flaggedPoints = { }
		for index = 1, #points do
			if collisionbox_flagcheck(flag, points[index], sweep) then
				table.insert(flaggedPoints, points[index])
			end
		end
		return flaggedPoints
	end
	ticks = 0
	screenMaxX = 240
	screenMaxY = 136
	spriteTransparencyKey = 0
	rolloverAmount = 4
	isDebug = false
	temp_system = "overworld"
	FLAG_COLLISION = 0
	FLAG_ENTRANCE  = 1
	BTN_UP    = 0
	BTN_DOWN  = 1
	BTN_LEFT  = 2
	BTN_RIGHT = 3
	PLAYER_UP    = 0
	PLAYER_DOWN  = 1
	PLAYER_LEFT  = 2
	PLAYER_RIGHT = 3
	FIRST_FRAME  = 0
	SECOND_FRAME = 1
	THIRD_FRAME  = 2
	screen = {
		mapX = 0,
		mapY = 0,
		minX = 4,
		minY = 2
	}
	entrances = {
		{
			name = "side1",
			mapX = 36,
			mapY = 20
		},
		{
			name = "side1",
			mapX = 36,
			mapY = 21
		},
		{
			name = "side2",
			mapX = 46,
			mapY = 20
		},
		{
			name = "side2",
			mapX = 46,
			mapY = 21
		},
		{
			name = "left",
			mapX = 29,
			mapY = 33
		},
		{
			name = "left",
			mapX = 30,
			mapY = 33
		},
		{
			name = "main",
			mapX = 38,
			mapY = 33
		},
		{
			name = "main",
			mapX = 39,
			mapY = 33
		},
		{
			name = "right",
			mapX = 47,
			mapY = 33
		},
		{
			name = "right",
			mapX = 48,
			mapY = 33
		}
	}
	player = {
		relativeX = (screenMaxX/2)-4,
		relativeY = (screenMaxY/2)-4,
		absoluteX = 0,
		absoluteY = 0,

		movementFrame = 0,
		direction     = 0,
		isBtnPressed  = false,
		characterId   = 3
	}
	function overworld_init()
		screen.mapX = 24*8
		screen.mapY = 27*8
		player.absoluteX = screen.mapX + player.relativeX
		player.absoluteY = screen.mapY + player.relativeY
		player.direction = 1
		collisionBox.topY    = player.relativeY + 6
		collisionBox.bottomY = player.relativeY + 7
		collisionBox.leftX   = player.relativeX
		collisionBox.rightX  = player.relativeX + 7
	end
	overworld_init()
	function check_overworld_movement()
		if btn(BTN_UP)    then
			player.isBtnPressed = true
			player.direction = PLAYER_UP
			collisionedPoints = collisionbox_flagchecks(FLAG_COLLISION, {0, 1}, {roofCheck = 1})
			if     #collisionedPoints == 0 then
				screen.mapY = screen.mapY - 1
			elseif #collisionedPoints == 1 then
				collisionPoint = collisionedPoints[1]
				if not collisionbox_flagcheck(FLAG_COLLISION, collisionPoint, {wallCheck = -rolloverAmount, roofCheck = 1}) then
					if     collisionPoint == 0 then
						screen.mapX = screen.mapX + 1
					elseif collisionPoint == 1 then
						screen.mapX = screen.mapX - 1
					end
				end
			end
		end
		if btn(BTN_DOWN)  then
			player.isBtnPressed = true
			player.direction = PLAYER_DOWN
			collisionedPoints = collisionbox_flagchecks(FLAG_COLLISION, {2, 3}, {roofCheck = 1})
			if     #collisionedPoints == 0 then
				screen.mapY = screen.mapY + 1
			elseif #collisionedPoints == 1 then
				collisionPoint = collisionedPoints[1]
				if not collisionbox_flagcheck(FLAG_COLLISION, collisionPoint, {wallCheck = -rolloverAmount, roofCheck = 1}) then
					if     collisionPoint == 2 then
						screen.mapX = screen.mapX + 1
					elseif collisionPoint == 3 then
						screen.mapX = screen.mapX - 1
					end
				end
			end
		end
		if btn(BTN_LEFT)  then
			player.isBtnPressed = true
			player.direction = PLAYER_LEFT
			collisionedPoints = collisionbox_flagchecks(FLAG_COLLISION, {0, 2}, {wallCheck = 1})
			if     #collisionedPoints == 0 then
				screen.mapX = screen.mapX - 1
			elseif #collisionedPoints == 1 then
				collisionPoint = collisionedPoints[1]
				if not collisionbox_flagcheck(FLAG_COLLISION, collisionPoint, {wallCheck = 1, roofCheck = -rolloverAmount}) then
					if     collisionPoint == 0 then
						screen.mapY = screen.mapY + 1
					elseif collisionPoint == 2 then
						screen.mapY = screen.mapY - 1
					end
				end
			end
		end
		if btn(BTN_RIGHT) then
			player.isBtnPressed = true
			player.direction = PLAYER_RIGHT
			collisionedPoints = collisionbox_flagchecks(FLAG_COLLISION, {1, 3}, {wallCheck = 1})
			if     #collisionedPoints == 0 then
				screen.mapX = screen.mapX + 1
			elseif #collisionedPoints == 1 then

				collisionPoint = collisionedPoints[1]

				if not collisionbox_flagcheck(FLAG_COLLISION, collisionPoint, {wallCheck = 1, roofCheck = -rolloverAmount}) then
					if     collisionPoint == 1 then
						screen.mapY = screen.mapY + 1
					elseif collisionPoint == 3 then
						screen.mapY = screen.mapY - 1
					end
				end
			end
		end

		if not (btn(BTN_UP) or btn(BTN_DOWN) or btn(BTN_LEFT) or btn(BTN_RIGHT)) then
			player.isBtnPressed = false
		end

		if screen.mapX < screen.minX then
			screen.mapX = screen.minX
		end
		if screen.mapY < screen.minY then
			screen.mapY = screen.minY
		end
	end

	function check_overworld_entrance()
		collisionedPoints = collisionbox_flagchecks(FLAG_ENTRANCE, {0, 1, 2, 3}, {wallCheck = -3})

		for index = 1, #collisionedPoints do
			absolutePoints = collisionbox_positioncheck(collisionedPoints[index], {wallCheck = -3})
			absoluteXBlock = math.floor(absolutePoints[1]/8)
			absoluteYBlock = math.floor(absolutePoints[2]/8)

			for subIndex = 1, #entrances do
				if absoluteXBlock == entrances[subIndex].mapX and
				   absoluteYBlock == entrances[subIndex].mapY then
					temp_system = entrances[subIndex].name
					return
				end
			end
		end
	end

	function temp_generate_animation_frame()
		frameTick = ticks % 40

		if     frameTick == 0 then
			player.frame = FIRST_FRAME
		elseif frameTick == 10 then
			player.frame = SECOND_FRAME
		elseif frameTick == 20 then
			player.frame = FIRST_FRAME
		elseif frameTick == 30 then
			player.frame = THIRD_FRAME
		end
	end

	function temp_show_debug_prompt()
		s = 1
		for i = -s, s do
			for j = -s, s do
				print("Press '1' for debug mode...", 4+i, 128+j, 8, false, 1)
			end
		end
		
		print("Press '1' for debug mode...", 4, 128, 9, false, 1)
	end

	showHitbox = false
	function temp_overworld_debug()
		function SCN(row)
			if not showHitbox then
				return
			end

			startOffset = 16323

			if row == collisionBox.topY or row == collisionBox.bottomY then
				poke(startOffset+0, 255)
				poke(startOffset+1, 75 )
				poke(startOffset+2, 43 )
			else
				poke(startOffset+0, 26 )
				poke(startOffset+1, 28 )
				poke(startOffset+2, 44 )
			end
		end

		rect(0,120,240,16,0)
		print("mapX:"..screen.mapX, 0, 122)
		print("mapY:"..screen.mapY, 0, 130)

		print("character(j):"..player.characterId, 50, 122)
		print("hitbox(h):"..tostring(showHitbox),  50, 130)

		isCollision = FLAG_COLLISION == 0
		print("collision(c):"..tostring(isCollision), 134, 122)

		if keyp(10) then
			player.characterId = player.characterId + 1
			if player.characterId == 4 then
				player.characterId = 0
			end
		end

		if keyp(8) then
			showHitbox = not showHitbox
		end

		if keyp(3) then
			if FLAG_COLLISION == -1 then
				FLAG_COLLISION = 0
				screen.minX = 4
				screen.minY = 2
			else
				FLAG_COLLISION = -1
				screen.minX = -1000
				screen.minY = -1000
			end
		end

		if showHitbox then
			rectb(collisionBox.leftX,  collisionBox.topY,    1, 1, 1)
			rectb(collisionBox.rightX, collisionBox.topY,    1, 1, 1)
			rectb(collisionBox.leftX,  collisionBox.bottomY, 1, 1, 1)
			rectb(collisionBox.rightX, collisionBox.bottomY, 1, 1, 1)
		end
	end
end

function overworld_system_loop()
	if temp_system == "overworld" then
		check_overworld_movement()
		temp_generate_animation_frame()

		check_overworld_entrance()

		collisionBox.screenMap.x = screen.mapX
		collisionBox.screenMap.y = screen.mapY

		map(screen.mapX/8, screen.mapY/8, 31, 18, -(screen.mapX%8), -(screen.mapY%8), -1)
		
		if not player.isBtnPressed then
			player.frame = 0
		end
		spriteId = 256 + (64*player.characterId) + (16*player.direction) + player.frame
		spr(spriteId, player.relativeX, player.relativeY, spriteTransparencyKey)

		map((screen.mapX/8)+120, (screen.mapY/8), 31, 18, -(screen.mapX%8), -(screen.mapY%8), 0)

		if keyp(28) then
			isDebug = not isDebug
		end
		if isDebug then
			temp_overworld_debug()
		else
			temp_show_debug_prompt()
		end
	else
		map(0, 119)
		print("You are in a different system now.", 28, 58)
		print("Press 'X' to go back.", 60, 68)
		print("System: "..temp_system, 78, 88)

		if key(24) then
			temp_system = "overworld"
			overworld_init()
		end
	end

	ticks = ticks + 1
end

make_system("overworld_system",overworld_system_init,overworld_system_loop)

-- end overworld
