-- title:  overworld
-- author: Saqib Malik
-- desc:   TunnelRunners overworld prototyping TIC.

function overworld_system_init()
    gsync(1|2|4|64, 3, false)

	--[[
	Globally used variables / constants.
	--]]
	ticks = 0
	screenMaxX = 240
	screenMaxY = 136
	spriteTransparencyKey = 0
	rolloverAmount = 4
	isDebug = false

	--[[
	Tile flags.
	--]]
	FLAG_COLLISION = 0
	FLAG_ENTRANCE  = 1

	--[[
	Button kepmapping.
	--]]
	BTN_UP    = 0
	BTN_DOWN  = 1
	BTN_LEFT  = 2
	BTN_RIGHT = 3

	--[[
	Player direction.
	--]]
	PLAYER_UP    = 0
	PLAYER_DOWN  = 1
	PLAYER_LEFT  = 2
	PLAYER_RIGHT = 3

	--[[
	Player frames.
	--]]
	FIRST_FRAME  = 0
	SECOND_FRAME = 1
	THIRD_FRAME  = 2

	--[[
	Controlling the screen (not including
	player sprite), aspects like the top-
	left map coordinates for map
	generation.
	--]]
	screen = {
		mapX = 0,
		mapY = 0,

		-- how small X and Y of map can go
		minX = 4,
		minY = 2
	}

	--[[
	All the entrances in the overworld.
	All X and Y position are tile positions
	and not pixel positions.
	]]--
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

	--[[
	Controlling various aspects about the
	current player in order to draw the
	player and their hitbox correctly.
	--]]
	overwrldPlayer = {
		relativeX = (screenMaxX/2)-4,
		relativeY = (screenMaxY/2)-4,
		absoluteX = 0,
		absoluteY = 0,

		movementFrame = 0,
		direction     = 0,
		isBtnPressed  = false,
		characterId   = 3
	}

	--[[
		overworld_init():
		Initializes screen map coordinates and
		player-related coordinates.
	--]]
	function overworld_init()
		-- this is effectively where I want the player to spawn
		screen.mapX = 24*8
		screen.mapY = 27*8

		-- just setting up the player's abolute X and Y
		-- positions (these are relative to the map bank)
		overwrldPlayer.absoluteX = screen.mapX + overwrldPlayer.relativeX
		overwrldPlayer.absoluteY = screen.mapY + overwrldPlayer.relativeY

		-- starting looking down
		overwrldPlayer.direction = 1

		-- setting up player's collisionbox
		collisionBox.topY    = overwrldPlayer.relativeY + 6
		collisionBox.bottomY = overwrldPlayer.relativeY + 7
		collisionBox.leftX   = overwrldPlayer.relativeX
		collisionBox.rightX  = overwrldPlayer.relativeX + 7
	end
	overworld_init()

	--[[
		check_overworld_movement():
			checks movement on the overworld.
	]]--
	function check_overworld_movement()
		----------------------------------
		-- Player pressed up button.    --
		----------------------------------
		if btn(BTN_UP)    then
			overwrldPlayer.isBtnPressed = true
			overwrldPlayer.direction = PLAYER_UP

			-- getting any of the collisionbox points that
			-- will end up colliding
			collisionedPoints = collisionbox_flagchecks(FLAG_COLLISION, {0, 1}, {roofCheck = 1})

			-- if none collide, sprite moves, otherwise if
			-- only one point collided we look into potentially
			-- performing a rollover
			if     #collisionedPoints == 0 then
				screen.mapY = screen.mapY - 1
			elseif #collisionedPoints == 1 then
				-- the singular point that collided
				collisionPoint = collisionedPoints[1]

				-- based on the point that collided, we see
				-- if non-collision space exists in a certain
				-- "rollover ammount" to push player into
				if not collisionbox_flagcheck(FLAG_COLLISION, collisionPoint, {wallCheck = -rolloverAmount, roofCheck = 1}) then
					if     collisionPoint == 0 then
						screen.mapX = screen.mapX + 1
					elseif collisionPoint == 1 then
						screen.mapX = screen.mapX - 1
					end
				end
			end
		end
		----------------------------------
		-- Player pressed down button.  --
		----------------------------------
		if btn(BTN_DOWN)  then
			overwrldPlayer.isBtnPressed = true
			overwrldPlayer.direction = PLAYER_DOWN

			-- getting any of the collisionbox points that
			-- will end up colliding
			collisionedPoints = collisionbox_flagchecks(FLAG_COLLISION, {2, 3}, {roofCheck = 1})

			-- if none collide, sprite moves, otherwise if
			-- only one point collided we look into potentially
			-- performing a rollover
			if     #collisionedPoints == 0 then
				screen.mapY = screen.mapY + 1
			elseif #collisionedPoints == 1 then
				-- the singular point that collided
				collisionPoint = collisionedPoints[1]

				-- based on the point that collided, we see
				-- if non-collision space exists in a certain
				-- "rollover ammount" to push player into
				if not collisionbox_flagcheck(FLAG_COLLISION, collisionPoint, {wallCheck = -rolloverAmount, roofCheck = 1}) then
					if     collisionPoint == 2 then
						screen.mapX = screen.mapX + 1
					elseif collisionPoint == 3 then
						screen.mapX = screen.mapX - 1
					end
				end
			end
		end
		----------------------------------
		-- Player pressed left button.  --
		----------------------------------
		if btn(BTN_LEFT)  then
			overwrldPlayer.isBtnPressed = true
			overwrldPlayer.direction = PLAYER_LEFT

			-- getting any of the collisionbox points that
			-- will end up colliding
			collisionedPoints = collisionbox_flagchecks(FLAG_COLLISION, {0, 2}, {wallCheck = 1})

			-- if none collide, sprite moves, otherwise if
			-- only one point collided we look into potentially
			-- performing a rollover
			if     #collisionedPoints == 0 then
				screen.mapX = screen.mapX - 1
			elseif #collisionedPoints == 1 then
				-- the singular point that collided
				collisionPoint = collisionedPoints[1]

				-- based on the point that collided, we see
				-- if non-collision space exists in a certain
				-- "rollover ammount" to push player into
				if not collisionbox_flagcheck(FLAG_COLLISION, collisionPoint, {wallCheck = 1, roofCheck = -rolloverAmount}) then
					if     collisionPoint == 0 then
						screen.mapY = screen.mapY + 1
					elseif collisionPoint == 2 then
						screen.mapY = screen.mapY - 1
					end
				end
			end
		end
		----------------------------------
		-- Player pressed right button. --
		----------------------------------
		if btn(BTN_RIGHT) then
			overwrldPlayer.isBtnPressed = true
			overwrldPlayer.direction = PLAYER_RIGHT

			-- getting any of the collisionbox points that
			-- will end up colliding
			collisionedPoints = collisionbox_flagchecks(FLAG_COLLISION, {1, 3}, {wallCheck = 1})

			-- if none collide, sprite moves, otherwise if
			-- only one point collided we look into potentially
			-- performing a rollover
			if     #collisionedPoints == 0 then
				screen.mapX = screen.mapX + 1
			elseif #collisionedPoints == 1 then
				-- the singular point that collided
				collisionPoint = collisionedPoints[1]

				-- based on the point that collided, we see
				-- if non-collision space exists in a certain
				-- "rollover ammount" to push player into
				if not collisionbox_flagcheck(FLAG_COLLISION, collisionPoint, {wallCheck = 1, roofCheck = -rolloverAmount}) then
					if     collisionPoint == 1 then
						screen.mapY = screen.mapY + 1
					elseif collisionPoint == 3 then
						screen.mapY = screen.mapY - 1
					end
				end
			end
		end

		-- checking if none of the buttons got pressed
		if not (btn(BTN_UP) or btn(BTN_DOWN) or btn(BTN_LEFT) or btn(BTN_RIGHT)) then
			overwrldPlayer.isBtnPressed = false
		end

		-- hard limits for top-left of the entire map
		if screen.mapX < screen.minX then
			screen.mapX = screen.minX
		end
		if screen.mapY < screen.minY then
			screen.mapY = screen.minY
		end
	end

	--[[
		check_overworld_entrance():
			checks if player entered an entrance.
	]]--
	function check_overworld_entrance()
		-- seeing if center of player collided with
		-- a tile that has the entrance flag set
		collisionedPoints = collisionbox_flagchecks(FLAG_ENTRANCE, {0, 1, 2, 3}, {wallCheck = -3})

		-- going through each of those points
		for index = 1, #collisionedPoints do
			-- getting X and Y block points of collision tiles
			absolutePoints = collisionbox_positioncheck(collisionedPoints[index], {wallCheck = -3})
			absoluteXBlock = math.floor(absolutePoints[1]/8)
			absoluteYBlock = math.floor(absolutePoints[2]/8)

			-- going through all entrances checking for
			-- a match, if one is made then indicates
			-- new system to load
			for subIndex = 1, #entrances do
				if absoluteXBlock == entrances[subIndex].mapX and
				   absoluteYBlock == entrances[subIndex].mapY then
					info_pass = entrances[subIndex].name
					current_system = "interior_level"
					return
				end
			end
		end
	end

	--[[
		temp_generate_animation_frame():
			used for generating animation frame, should
			later be removed.
	]]--
	function temp_generate_animation_frame()
		frameTick = ticks % 40

		if     frameTick == 0 then
			overwrldPlayer.frame = FIRST_FRAME
		elseif frameTick == 10 then
			overwrldPlayer.frame = SECOND_FRAME
		elseif frameTick == 20 then
			overwrldPlayer.frame = FIRST_FRAME
		elseif frameTick == 30 then
			overwrldPlayer.frame = THIRD_FRAME
		end
	end

	--[[
		temp_show_debug_prompt()
			shows prompt to enable debug mode.
	]]--
	function temp_show_debug_prompt()
		s = 1
		for i = -s, s do
			for j = -s, s do
				print("Press '1' for debug mode...", 4+i, 128+j, 8, false, 1)
			end
		end
		
		print("Press '1' for debug mode...", 4, 128, 9, false, 1)
	end

	--[[
		temp_overworld_debug():
			debug stuff for the overworld prototype, should
			later be removed.
	]]--
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

		print("character(j):"..overwrldPlayer.characterId, 50, 122)
		print("hitbox(h):"..tostring(showHitbox),  50, 130)

		isCollision = FLAG_COLLISION == 0
		print("collision(c):"..tostring(isCollision), 134, 122)

		if keyp(10) then
			overwrldPlayer.characterId = overwrldPlayer.characterId + 1
			if overwrldPlayer.characterId == 4 then
				overwrldPlayer.characterId = 0
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
	-- checking if system was transferred with new info
	if info_pass ~= nil then
		if     info_pass == "side1" then
			screen.mapX = 177
			screen.mapY = 102
			overwrldPlayer.direction = PLAYER_RIGHT
		elseif info_pass == "side2" then
			screen.mapX = 247
			screen.mapY = 102
			overwrldPlayer.direction = PLAYER_LEFT
		elseif info_pass == "left"  then
			screen.mapX = 120
			screen.mapY = 202
			overwrldPlayer.direction = PLAYER_DOWN
		elseif info_pass == "main"  then
			screen.mapX = 192
			screen.mapY = 202
			overwrldPlayer.direction = PLAYER_DOWN
		elseif info_pass == "right" then
			screen.mapX = 264
			screen.mapY = 202
			overwrldPlayer.direction = PLAYER_DOWN
		end
		info_pass = nil
	end

	-- checking player movement and animation frame
	check_overworld_movement()
	temp_generate_animation_frame()

	-- checking if player entered something
	check_overworld_entrance()

	-- changing the collisionbox's screen position, this is
	-- required to make the collisionbox work
	collisionBox.screenMap.x = screen.mapX
	collisionBox.screenMap.y = screen.mapY

	-- drawing map based on how player moves
	map(screen.mapX/8, screen.mapY/8, 31, 18, -(screen.mapX%8), -(screen.mapY%8), -1)
		
	-- drawing sprite based on player direction and frame
	if not overwrldPlayer.isBtnPressed then
		overwrldPlayer.frame = 0
	end
	spriteId = 256 + (64*overwrldPlayer.characterId) + (16*overwrldPlayer.direction) + overwrldPlayer.frame
	spr(spriteId, overwrldPlayer.relativeX, overwrldPlayer.relativeY, spriteTransparencyKey)

	-- drawing overlay map
	map((screen.mapX/8)+120, (screen.mapY/8), 31, 18, -(screen.mapX%8), -(screen.mapY%8), 0)

	-- checking to see if we should enable debug mode
	if keyp(28) then
		isDebug = not isDebug
	end
	-- enabling/prompting debug mode
	if isDebug then
		-- temp_overworld_debug()
	else
		-- temp_show_debug_prompt()
	end

	ticks = ticks + 1
end

make_system("overworld_system", overworld_system_init, overworld_system_loop)

-- end overworld
