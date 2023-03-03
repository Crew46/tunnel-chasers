---
--- Created by dkienenb.
--- DateTime: 2/21/23 9:56 AM
--- graphics library
pc_spr={
  --character sprites are located in the sprite sheet of bank 1
  --the first sprite is located on 256
  --the last sprite is located on 511
  --each character has up to 64 8x8 sprites
  --left sprites are even, two spaces away from each other
  --right sprites are odd, two spaces away from each other
  --the character is facing forward
  dpig={


    headfl_a=256,
    headfr_a=257,
    headfl_b=258,
    headfr_b=259,
    headbl_a=260,
    headbr_a=261,
    headbl_b=262,
    headbr_b=263,

  }
}

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
