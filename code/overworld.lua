-- title:  overworld
-- author: Saqib Malik
-- desc:   TunnelRunners overworld prototyping TIC.

function overworld_system_init()
    gsync( 1|2|4|64,3,false)

	----------------------------------------------------------
	--                COLLISIONBOX LIBRARY                  --
	----------------------------------------------------------
	--[[
		Keeps track of various properties used for the
		collisionbox and its functions.
	]]--
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
	--[[
		collisionbox_positioncheck():
			checks the absolute position at a specified point on
			the collisionbox, or around that point.

		point (number) - REQUIRED:
			which part of the collisionbox to check at...
			0 - top left
			1 - top right
			2 - bottom left
			3 - bottom right

		sweep (table) - OPTIONAL:
			properties to check around the point...
			{
				wallCheck = number (default 0),
				roofCheck = number (default 0)
			}

		returns (table):
			absolute position of tile, or point around
			it... first item is absolute X position and
			second item is absolute Y position.

		remarks:
			check out the 'collisionbox_tilecheck()' function
			before considering this one.
	]]--
	function collisionbox_positioncheck(point, sweep)
		-- since sweep is an optional parameter, if it's nil
		-- it is just set to a blank table to avoid problems
		-- later when attempting to grab sweep's properties
		sweep = sweep or { }

		-- what will eventually be used to get position of tile
		-- number to return
		absoluteX = collisionBox.screenMap.x
		absoluteY = collisionBox.screenMap.y

		-- what point of the collisionbox to check tile of
		if     point == 0 then
			-- starting straight at collisionbox point
			absoluteX = absoluteX + collisionBox.leftX
			absoluteY = absoluteY + collisionBox.topY

			-- seeing if we should read to the left/right or
			-- bottom/top of the point, and how much if so
			if sweep.wallCheck then
				absoluteX = absoluteX - sweep.wallCheck
			end
			if sweep.roofCheck then
				absoluteY = absoluteY - sweep.roofCheck
			end
		elseif point == 1 then
			-- starting straight at collisionbox point
			absoluteX = absoluteX + collisionBox.rightX
			absoluteY = absoluteY + collisionBox.topY

			-- seeing if we should read to the left/right or
			-- bottom/top of the point, and how much if so
			if sweep.wallCheck then
				absoluteX = absoluteX + sweep.wallCheck
			end
			if sweep.roofCheck then
				absoluteY = absoluteY - sweep.roofCheck
			end
		elseif point == 2 then
			-- starting straight at collisionbox point
			absoluteX = absoluteX + collisionBox.leftX
			absoluteY = absoluteY + collisionBox.bottomY

			-- seeing if we should read to the left/right or
			-- bottom/top of the point, and how much if so
			if sweep.wallCheck then
				absoluteX = absoluteX - sweep.wallCheck
			end
			if sweep.roofCheck then
				absoluteY = absoluteY + sweep.roofCheck
			end
		elseif point == 3 then
			-- starting straight at collisionbox point
			absoluteX = absoluteX + collisionBox.rightX
			absoluteY = absoluteY + collisionBox.bottomY

			-- seeing if we should read to the left/right or
			-- bottom/top of the point, and how much if so
			if sweep.wallCheck then
				absoluteX = absoluteX + sweep.wallCheck
			end
			if sweep.roofCheck then
				absoluteY = absoluteY + sweep.roofCheck
			end
		else
			-- invalid point throws error
			error("Collisionbox point out-of-bounds.", 2)
		end

		return {absoluteX, absoluteY}
	end
	--[[
		collisionbox_tilecheck():
			checks the tile number at a specified point on the
			collisionbox, or around that point.

		point (number) - REQUIRED:
			which part of the collisionbox to check at...
			0 - top left
			1 - top right
			2 - bottom left
			3 - bottom right

		sweep (table) - OPTIONAL:
			properties to check around the point...
			{
				wallCheck = number (default 0),
				roofCheck = number (default 0)
			}

		returns (number):
			tile number on the given point.

		remarks:
			if one wanted to read two pixels to the left
			of the top left hitbox their function call
			would look like...
			collisionbox_tilecheck(0, {wallCheck = 2})

			if both 'wallCheck' and 'roofChech' have values,
			then we are reading diagonally from the
			collisionbox's point.
	]]--
	function collisionbox_tilecheck(point, sweep)
		absolutePositions = collisionbox_positioncheck(point, sweep)
		return mget(absolutePositions[1]/8, absolutePositions[2]/8)
	end
	--[[
		collisionbox_flagcheck():
			checks if a flag is set at a specified point's tile
			on the collisionbox, or around that point's tile.

		flag (number) - REQUIRED:
			the flag to check if set, should be 0-7.

		returns (boolean):
			true or false if the flag was checked on the point.

		remarks:
			for a more detailed explanation of this function, see
			the summary comments for the 'collisionbox_tilecheck()'
			as they apply here.
	]]--
	function collisionbox_flagcheck(flag, point, sweep)
		tile = collisionbox_tilecheck(point, sweep)
		return fget(tile, flag)
	end
	--[[
		collisionbox_flagchecks():
			checks if a flag is set at multiple point's tiles
			on the collisionbox, or around those point's tiles.

		flag (number) - REQUIRED:
			the flag to check if set for all points, should be 0-7.

		points (number array) - REQUIRED:
			parts of the collisionbox to check, should never
			have more than 4 points.

		returns (table):
			all points which had flag set.

		remarks:
			for a more detailed explanation of this function, see
			the summary comments for the 'collisionbox_tilecheck()'
			as they apply here.
			
			'sweep' parameter will apply to all points
	]]--
	function collisionbox_flagchecks(flag, points, sweep)
		flaggedPoints = { }
		for index = 1, #points do
			if collisionbox_flagcheck(flag, points[index], sweep) then
				table.insert(flaggedPoints, points[index])
			end
		end
		return flaggedPoints
	end

	----------------------------------------------------------
	--                MAIN PROTOTYPE CODE                   --
	----------------------------------------------------------
	-- title:  tunnelrunners_overworld_prototype
	-- version: 4
	-- author: Saqib Malik
	-- desc:   TunnelRunners overworld prototyping TIC.
	-- script: lua

	--[[
	Globally used variables / constants.
	--]]
	ticks = 0
	screenMaxX = 240
	screenMaxY = 136
	spriteTransparencyKey = 0
	rolloverAmount = 4
	isDebug = false
	-- this should be removed in final version
	temp_system = "overworld"

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
		player.absoluteX = screen.mapX + player.relativeX
		player.absoluteY = screen.mapY + player.relativeY

		-- starting looking down
		player.direction = 1

		-- setting up player's collisionbox
		collisionBox.topY    = player.relativeY + 6
		collisionBox.bottomY = player.relativeY + 7
		collisionBox.leftX   = player.relativeX
		collisionBox.rightX  = player.relativeX + 7
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
			player.isBtnPressed = true
			player.direction = PLAYER_UP

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
			player.isBtnPressed = true
			player.direction = PLAYER_DOWN

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
			player.isBtnPressed = true
			player.direction = PLAYER_LEFT

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
			player.isBtnPressed = true
			player.direction = PLAYER_RIGHT

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
			player.isBtnPressed = false
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
					temp_system = entrances[subIndex].name
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
			player.frame = FIRST_FRAME
		elseif frameTick == 10 then
			player.frame = SECOND_FRAME
		elseif frameTick == 20 then
			player.frame = FIRST_FRAME
		elseif frameTick == 30 then
			player.frame = THIRD_FRAME
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
	-- simualates final "systems" functionality
	-- in main tunnels TIC
	if temp_system == "overworld" then
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
		if not player.isBtnPressed then
			player.frame = 0
		end
		spriteId = 256 + (64*player.characterId) + (16*player.direction) + player.frame
		spr(spriteId, player.relativeX, player.relativeY, spriteTransparencyKey)

		-- drawing overlay map
		map((screen.mapX/8)+120, (screen.mapY/8), 31, 18, -(screen.mapX%8), -(screen.mapY%8), 0)

		-- checking to see if we should enable debug mode
		if keyp(28) then
			isDebug = not isDebug
		end
		-- enabling/prompting debug mode
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
