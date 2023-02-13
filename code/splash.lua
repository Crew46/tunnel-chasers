---
--- Created by dkienenb.
--- DateTime: 2/13/23 12:33 PM
--- Splash screen prior to menu

function splash()
  cls(13)
  print_centered("Placeholder splash screen (->)", 240/2, 136/2)
  if btn(3) then
    current_system = "main_menu"
  end
end

make_system("splash", nil, splash)

-- end splash
