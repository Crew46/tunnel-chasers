---
--- Created by dkienenb.
--- DateTime: 2/13/23 12:33 PM
--- Splash screen generator

function make_splash_system(system_name, next_system, render_function, color)
  function splash()
    if color then
      cls(color)
    end
    if render_function then
      render_function()
    end
    print_centered("(Press Z to continue)", 180, 125)
    if btnp(4) then
      current_system = next_system
    end
  end

  make_system(system_name, nil, splash)
end

-- end splash
