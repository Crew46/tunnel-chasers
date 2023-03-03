---
--- Created by dkienenb.
--- Engine
---
current_system = "intro"
previous_system = nil

systems = {}

function hardlink_system(link_name, source)
  systems[link_name] = systems[source]
end

function symlink_system(link_name, source)
  make_system(link_name, function() current_system = source end)
end

function make_system(name, initFunction, loopFunction)
  systems[name] = { init = initFunction, loop = loopFunction }
end

function get_system(name)
  return systems[name]
end

function TIC()
  local cache = current_system
  if current_system then
    local system = get_system(current_system)
    if system then
      if previous_system ~= current_system and system.init then
        system.init()
      end
      if system.loop then
        system.loop()
      end
    else
      trace("Invalid system: " .. current_system)
      exit()
    end
  end
  previous_system = cache;
end

-- end engine
