-- title:   TunnelRunner (placeholder)
-- author:  crew46
-- desc:    gaming
-- site:    https://github.com/Crew46/
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

---
--- Created by dkienenb.
--- Engine
---
current_system = "menu"
previous_game_system = nil

systems = {}

function make_system(name, initFunction, tickFunction)
    systems[name] = {init=initFunction, tick=tickFunction}
end

function get_system(name)
    return systems[name]
end

function TIC()
    if current_system then
        local system = get_system(current_system)
        if system then
            if previous_game_system ~= current_system and system.init then
                system.init()
            end
            if system.tick then
                system.tick();
            end
        end
    end
    previous_game_system = current_system;
end

-- end engine
