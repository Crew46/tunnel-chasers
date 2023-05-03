-- title:   Tunnel Chasers
-- author:  danmuck
-- desc:    Inventory/Items
-- script:  lua
--[[

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
    uses = 1,
    effect = function()
        
    end
}     
Item.__index = Item

--[[
        ========================
        effects           ======
]]
active_boosts = {}

function new_boost(boost_timer, boost_type)
    local new_boost = {boost_timer, boost_type}
    table.insert(active_boosts, new_boost)
end

function add_speed()
    new_boost(360, "speed")
    player.speed = player.speed + .5
end

function add_charisma()
    new_boost(360, "charisma")
    player.charisma = player.charisma + .5
end


function check_boosts(active_boosts)
    local boost_values = {
        acuity = .5,
        charisma = .5,
        ingenuity = .5,
        speed = .5
    }
    
    for _, boost in ipairs(active_boosts) do
        local timer = boost[1]
        local name = boost[2]

        if timer ~= 0 then
            timer = timer - 1
        else
            player[name] = player[name] - boost_values[name]
            table.remove(active_boosts, _)
        end
        boost[1] = timer
    end
end

function add_life()
    player.lives = player.lives + 1
end

function unlock_door(door_type)
    
end


function Item:new(name, type, mode, spr_id, uses, effect)
    local new_item = setmetatable({}, {__index = Item})

    new_item.name = name
    new_item.type = type
    new_item.mode = mode
    new_item.spr_id = spr_id
    if uses ~= nil then
        new_item.uses = uses
    else
        new_item.uses = 1
    end
    if effect ~= nil then
        new_item.effect = effect
    else
        new_item.effect = nil
    end

    table.insert(Item_bank, new_item)
    return new_item
end

Item_bank = {}
key_grey    = Item:new("Grey Key", "key", 7, 448)                       -- 1
key_gold    = Item:new("Gold Key", "key", 7, 464)                       -- 2
lock_pick   = Item:new("Lockpick", "key", 7, 352, 5)                    -- 3
donut       = Item:new("Donut", "weapon", 7, 386)                       -- 4
coin        = Item:new("Coin", "power_up", 7, 356, 1, add_life)         -- 5
first_aid   = Item:new("First Aid", "power_up", 7, 417)                 -- 6
energy      = Item:new("Energy", "power_up", 7, 403, 1, add_speed)      -- 7


--[[
        ===============================
        INVENTORY                ======
        ===============================

        hold x to move between inv slots with arrow keys
        5 banks with 1 selector bank
]]

function item_to_inv(item_id)
    local tmp = copy(Item_bank[item_id])
    table.insert(player.inventory, tmp)
    return tmp
end

function cycle_inv(inv)
    if #inv == 0 then
        return
    end
    local tmp = table.remove(inv, 1)
    if tmp.uses ~= 0 then
        table.insert(inv, tmp)
    end
end

function use_item(inv)
    if inv[1] ~= nil then
        current_item = inv[1]
    else
        return
    end
    current_item.uses = current_item.uses - 1
    if current_item.effect ~= nil then
        current_item.effect()
    end
    if current_item.uses == 0 then
        cycle_inv(inv)
    end
end

function draw_inv(inv)
    local anchor_x = 198
    local anchor_y = 120
    local c_k = -1 
    local offset = 0

    vbank(1)
    spr(354, anchor_x, anchor_y, c_k, 1)
    spr(355, anchor_x + 8, anchor_y, c_k, 1)
    spr(355, anchor_x + 16, anchor_y, c_k, 1)
    spr(355, anchor_x + 24, anchor_y, c_k, 1)
    spr(355, anchor_x + 32, anchor_y, c_k, 1)

    vbank(0)
    for i = 1, 5 do 
        if inv[i] ~= nil then
            spr(inv[i].spr_id, anchor_x + offset, anchor_y, c_k, 1)
            offset = offset + 8
        end
    end
end



--[[
    ===============================
    DEBUG                    ======
    ===============================
    ]]

player_inventory = {}
test_inv = {key_grey, key_gold, coin, first_aid, energy, donut, lock_pick}

function inv_init()
    gsync(0, 0, false)
    cls()
    cycle_inv(test_inv)
    draw_inv(test_inv)
    add_life()
end

--make_system("inv_debug", inv_init, nil)

-- java -jar ticify.jar
