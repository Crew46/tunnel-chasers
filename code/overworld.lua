-- title:  overworld
-- author: Saqib Malik
-- desc:   TunnelRunners overworld prototyping TIC.

function overworld_system_init()
    sync( 1|2|4,3,false)

    --[[
    Globally used variables / constants.
    --]]
    ticks = 0
    screenMaxX = 240
    screenMaxY = 136
    spriteTransparencyKey = 0
    rolloverAmount = 4

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
        mapY = 0
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
        characterId   = 0
    }
    playerHitbox = {
        topY    = 0,
        bottomY = 0,
        leftX   = 0,
        rightX  = 0
    }

    --[[
        overworld_init():
        Initializes screen map coordinates and
        player-related coordinates.
    --]]
    function overworld_init()
        -- this is effectively where I want the player to spawn
        screen.mapX = 52--60
        screen.mapY = 66--76

        -- just setting up the player's abolute X and Y
        -- positions (these are relative to the map bank)
        player.absoluteX = screen.mapX+player.relativeX
        player.absoluteY = screen.mapY+player.relativeY

        -- starting looking down
        player.direction = 1

        -- setting up player's hitbox
        playerHitbox.topY    = player.relativeY
        playerHitbox.bottomY = player.relativeY+7
        playerHitbox.leftX   = player.relativeX+1
        playerHitbox.rightX  = player.relativeX+6
    end
    overworld_init()


    showHitbox = false
    function overworld_debug()
        function SCN(row)
            startOffset = 16323

            if row == playerHitbox.topY or row == playerHitbox.bottomY then
        poke(startOffset+0, 255)
    poke(startOffset+1, 75 )
    poke(startOffset+2, 43 )
    else
        poke(startOffset+0, 26)
    poke(startOffset+1, 28)
    poke(startOffset+2, 44)
    end
        end

        rect(0,120,240,16,0)
        print("mapX:"..screen.mapX, 0, 122)
        print("mapY:"..screen.mapY, 0, 130)

        print("character(j):"..player.characterId, 50, 122)
    print("hitbox(h):"..tostring(showHitbox), 50, 130)

        if keyp(10) then
            player.characterId = player.characterId+1
            if player.characterId == 4 then
                player.characterId = 0
            end
        end

        if keyp(8) then
            showHitbox = not showHitbox
        end

        if showHitbox then
            rectb(playerHitbox.leftX,  playerHitbox.topY,    1, 1, 1)
            rectb(playerHitbox.rightX, playerHitbox.topY,    1, 1, 1)
            rectb(playerHitbox.leftX,  playerHitbox.bottomY, 1, 1, 1)
            rectb(playerHitbox.rightX, playerHitbox.bottomY, 1, 1, 1)
        end
    end

    function check_overworld_movement()
        if btn(BTN_UP)    then
            player.isBtnPressed = true

            player.direction = PLAYER_UP
            screen.mapY = screen.mapY-1
            if     topleft_hitbox_collision()  then
                screen.mapY = screen.mapY+1
                topleft_hitbox_rollover()
            elseif topright_hitbox_collision() then
                screen.mapY = screen.mapY+1
                topright_hitbox_rollover()
            end
        end
        if btn(BTN_DOWN)  then
            player.isBtnPressed = true

            player.direction = PLAYER_DOWN
            screen.mapY = screen.mapY+1
            if     bottomleft_hitbox_collision()  then
                screen.mapY = screen.mapY-1
                bottomleft_hitbox_rollover()
            elseif bottomright_hitbox_collision() then
                screen.mapY = screen.mapY-1
                bottomright_hitbox_rollover()
            end
        end
        if btn(BTN_LEFT)  then
            player.isBtnPressed = true

            player.direction = PLAYER_LEFT
            screen.mapX = screen.mapX-1
            if     topleft_hitbox_collision()    then
                screen.mapX = screen.mapX+1
                topleft_hitbox_rollover()
            elseif bottomleft_hitbox_collision() then
                screen.mapX = screen.mapX+1
                bottomleft_hitbox_rollover()
            end
        end
        if btn(BTN_RIGHT) then
            player.isBtnPressed = true

            player.direction = PLAYER_RIGHT
            screen.mapX = screen.mapX+1
            if     topright_hitbox_collision()    then
                screen.mapX = screen.mapX-1
                topright_hitbox_rollover()
            elseif bottomright_hitbox_collision() then
                screen.mapX = screen.mapX-1
                bottomright_hitbox_rollover()
            end
        end

        if not (btn(BTN_UP) or btn(BTN_DOWN) or btn(BTN_LEFT) or btn(BTN_RIGHT)) then
            player.isBtnPressed = false
        end

        if screen.mapX < 2 then
            screen.mapX = 2
        end
        if screen.mapY < 0 then
            screen.mapY = 0
        end
    end

    function topleft_hitbox_collision()
        return fget(mget((screen.mapX+playerHitbox.leftX)/8,  (screen.mapY+playerHitbox.topY)/8), FLAG_COLLISION)
    end
    function topright_hitbox_collision()
        return fget(mget((screen.mapX+playerHitbox.rightX)/8, (screen.mapY+playerHitbox.topY)/8), FLAG_COLLISION)
    end
    function bottomleft_hitbox_collision()
        return fget(mget((screen.mapX+playerHitbox.leftX)/8,  (screen.mapY+playerHitbox.bottomY)/8), FLAG_COLLISION)
    end
    function bottomright_hitbox_collision()
        return fget(mget((screen.mapX+playerHitbox.rightX)/8, (screen.mapY+playerHitbox.bottomY)/8), FLAG_COLLISION)
    end

    function topleft_hitbox_rollover()
        if     btn(BTN_UP)   and not btn(BTN_LEFT) then
            if not fget(mget((screen.mapX+playerHitbox.leftX+rolloverAmount)/8, (screen.mapY+playerHitbox.topY-1)/8), FLAG_COLLISION) then
                screen.mapX = screen.mapX+1
            end
        elseif btn(BTN_LEFT) and not btn(BTN_UP) then
            if not fget(mget((screen.mapX+playerHitbox.leftX-1)/8, (screen.mapY+playerHitbox.topY+rolloverAmount)/8), FLAG_COLLISION) then
                screen.mapY = screen.mapY+1
            end
        end
    end
    function topright_hitbox_rollover()
        if     btn(BTN_UP) and not btn(BTN_RIGHT) then
            if not fget(mget((screen.mapX+playerHitbox.rightX-rolloverAmount)/8, (screen.mapY+playerHitbox.topY-1)/8), FLAG_COLLISION) then
                screen.mapX = screen.mapX-1
            end
        elseif btn(BTN_RIGHT) and not btn(BTN_UP) then
            if not fget(mget((screen.mapX+playerHitbox.rightX+1)/8, (screen.mapY+playerHitbox.topY+rolloverAmount)/8), FLAG_COLLISION) then
                screen.mapY = screen.mapY+1
            end
        end
    end
    function bottomleft_hitbox_rollover()
        if     btn(BTN_DOWN) then
            if not fget(mget((screen.mapX+playerHitbox.leftX+rolloverAmount)/8, (screen.mapY+playerHitbox.bottomY+1)/8), FLAG_COLLISION) then
                screen.mapX = screen.mapX+1
            end
        elseif btn(BTN_LEFT) then
            if not fget(mget((screen.mapX+playerHitbox.leftX-1)/8, (screen.mapY+playerHitbox.bottomY-rolloverAmount)/8), FLAG_COLLISION) then
                screen.mapY = screen.mapY-1
            end
        end
    end
    function bottomright_hitbox_rollover()
        if     btn(BTN_DOWN) then
            if not fget(mget((screen.mapX+playerHitbox.rightX-rolloverAmount)/8, (screen.mapY+playerHitbox.bottomY+1)/8), FLAG_COLLISION) then
                screen.mapX = screen.mapX-1
            end
        elseif btn(BTN_RIGHT) then
            if not fget(mget((screen.mapX+playerHitbox.rightX+1)/8, (screen.mapY+playerHitbox.bottomY-rolloverAmount)/8), FLAG_COLLISION) then
                screen.mapY = screen.mapY-1
            end
        end
    end

    function temp_generate_animation_frame()
        frameTick = ticks%40

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
end

function overworld_system_loop()
	-- checking player movement and animation frame
	check_overworld_movement()
	temp_generate_animation_frame()

	-- drawing map based on how player moves
	map(screen.mapX/8, screen.mapY/8, 31, 18, -(screen.mapX%8), -(screen.mapY%8), -1)
	
	-- drawing sprite based on player direction and frame
	if not player.isBtnPressed then
		player.frame = 0
	end
	spriteId = 256+(64*player.characterId)+(16*player.direction)+player.frame
	spr(spriteId, player.relativeX, player.relativeY, spriteTransparencyKey)

 map((screen.mapX/8)+120, (screen.mapY/8), 31, 18, -(screen.mapX%8), -(screen.mapY%8), 0)
	overworld_debug()

	ticks = ticks+1
end

make_system("overworld_system",overworld_system_init,overworld_system_loop)

-- end overworld

