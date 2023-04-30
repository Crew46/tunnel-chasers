-- title:   Tunnel Chasers
-- author:  danmuck
-- desc:    Inventory/Items
-- script:  lua
--[[ java -jar ticify.jar

[0] keys

    • Keys: to open locked doors.
    
    • Lockpick (Nox ONLY; starts with 1): Can be reused up to five times 

[1] weapons 

    • Donuts (sneak): the Player can strategically place donuts on the floor to distract Officers from their patrolling paths.

[2] player powerups

    • Coins: these are scarce around the levels. Coins are used as lifes; whenever the Player is arrested and sent to court, the Player may use the coins to pay a fine and Continue where they left off. Otherwise, it's game over and the Player is sent to Jail.

    • First Aid Kit (sneak): whenever the Player receives damage, the Player can heal themselves as long as they have First Aid Kits.

    • Energy Drink (runner): During a chase scene, the Player can use an energy drinks to get a temporary speed boost to outrun the chasing Officer.

]]


--[[
        ===============================
        ITEMS                    ======
        ===============================

        id based on table position
]]

Item = {
    name = "",

    type = "", --[[
        - key
        - weapon
        - power_up
    ]]
    mode = 0, --[[
        - sneak         (1)
        - runner        (2)
        - overworld     (4)
    ]]
    spr_id = 0,
    effect = function()
        
    end
}     
Item.__index = Item


testing_index = 2
function add_life()
    testing_index = testing_index + 8
    player.lives = player.lives + 1
    -- print(player.lives, testing_index, 120, 2)
end
function add_speed()
    testing_index = testing_index + 12
    player.speed = player.speed + .5
    -- print(player.speed, testing_index, 128, 2)
end


function Item:new(name, type, mode, spr_id, effect)
    local new_item = setmetatable({}, {__index = Item})

    new_item.name = name
    new_item.type = type
    new_item.mode = mode
    new_item.spr_id = spr_id
    if effect ~= nil then
        new_item.effect = effect
    end

    table.insert(Item_bank, new_item)
    return new_item
end

Item_bank = {}
key_grey    = Item:new("Grey Key", "key", 7, 448)
key_gold    = Item:new("Gold Key", "key", 7, 464)
lock_pick   = Item:new("Lockpick", "key", 7, 352)
donut       = Item:new("Donut", "weapon", 7, 386)
coin        = Item:new("Coin", "power_up", 7, 356, add_life)
first_aid   = Item:new("First Aid", "power_up", 7, 417)
energy      = Item:new("Energy", "power_up", 7, 403, add_speed)


Item_runner = {}
Item_runner.__index = Item
setmetatable(Item_runner, Item)


--[[
        ===============================
        INVENTORY                ======
        ===============================

        hold x to move between inv slots with arrow keys
        5 banks with 1 selector bank
]]
player_inventory = {}
test_inv = {key_grey, key_gold, coin, first_aid, energy, donut, lock_pick}

function draw_items(inv)
    local anchor_x = 198
    local anchor_y = 120
    local c_k = -1 
    local offset = 0

    for i = 1, 5 do 
        if inv[i] ~= nil then
            spr(inv[i].spr_id, anchor_x + offset, anchor_y, c_k, 1)
            offset = offset + 8
        end
    end
    
end

function draw_inv(inv)
    --   x  y   x    y   color
    -- line(0, 0, 240, 136, 2)
    -- line(240, 0, 0, 136, 2)

    -- line(0, 0, 240, 0, 2)
    -- line(0, 135, 240, 135, 2)

    -- line(0, 0, 0, 136, 2)
    -- line(239, 0, 239, 136, 2)
    -- DELETE


    local anchor_x = 198
    local anchor_y = 120
    local c_k = -1 

    vbank(0)
    spr(354, anchor_x, anchor_y, c_k, 1)
    spr(355, anchor_x + 8, anchor_y, c_k, 1)
    spr(355, anchor_x + 16, anchor_y, c_k, 1)
    spr(355, anchor_x + 24, anchor_y, c_k, 1)
    spr(355, anchor_x + 32, anchor_y, c_k, 1)

    vbank(1)
    draw_items(inv)
    
    
end

function cycle_inv(inv)
    local tmp = table.remove(inv, 1)
    table.insert(inv, tmp)
    -- draw_inv(inv)
end




--[[
    ===============================
    DEBUG                    ======
    ===============================
    ]]

function inv_init()
    gsync(0, 0, false)
    cls()
    cycle_inv(test_inv)
    draw_inv(test_inv)
    add_life()
end

make_system("inv_debug", inv_init, nil)
