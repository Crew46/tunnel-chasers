---
--- Created by dkienenb.
--- DateTime: 2/21/23 9:56 AM
--- graphics library

function draw(sprite_name, sprite_variant, x, y, scale)
  local sprite_number
  local color_key = -1
  local flip = 0
  local rotate = 0
  local width = 1
  local height = 1
  if sprite_name then
    if sprite_name == "player_portrait" then
      local portraits = {8, 8, 0, 8, 226}
      sprite_number = portraits[sprite_variant]
      width = 2
      height = 2
    elseif sprite_name == "player_portrait_box" then
      rectb(x, y, 32, 32, 11)
    end
  end
  if sprite_number then
    spr(sprite_number, x, y, color_key, scale or 1, flip, rotate, width, height)
  end
end

-- end graphics
