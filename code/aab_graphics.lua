---
--- Created by dkienenb.
--- DateTime: 2/21/23 9:56 AM
--- graphics library

function draw(thing, variant, x, y, scale)
  local sprite_number
  local color_key = -1
  local flip = 0
  local rotate = 0
  local width = 1
  local height = 1
  if thing == "player_portrait" then
    local portraits = {8, 8, 0, 8, 226}
    sprite_number = portraits[variant]
    width = 2
    height = 2
  end
  spr(sprite_number, x, y, color_key, scale or 1, flip, rotate, width, height)
end

-- end graphics
