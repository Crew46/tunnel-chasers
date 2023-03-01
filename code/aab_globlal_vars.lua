---
--- Created by AshBC91
--- DateTime: 2/25/23 7:57 PM
--- Global Variables

bttn={u=0,d=1,l=2,r=3,z=4,x=5,a=6,s=7}
player={
  spr_id=0,
  speed=1,
  lives=3,
  ingenuity=3,
  charisma=1,
  acuity=3,
  honesty=0,
  building="Mechung_hall",
  progression={},
  pc={
    {
      name="BYzLi",
      skill_desc="Charismatic",
      ingenuity=4,
      charisma=3
    },
    {
      name="DirtPig",
      skill_desc="Fast",
    },
    {
      name="Paradox",
      skill_desc="Thin",
      ingenuity=4
    },
    {
      name="Null",
      skill_desc="Equipped",
      ingenuity=2
    },
    {
      name="Plant",
      skill_desc="Plant",
    },
    index=1
  }
}
pc_spr={
  --character sprites are located in the sprite sheet of bank 1
  --the first sprite is located on 256
  --the last sprite is located on 511
  --each character has up to 64 8x8 sprites
  --left sprites are even, two spaces away from each other
  --right sprites are odd, two spaces away from each other
  --the character is facing forwar
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
-- end Global Variables