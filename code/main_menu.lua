---
--- Created by dkienenb.
--- DateTime: 2/10/23 5:56 PM
--- Menu system
---

make_system_selector_menu_system("main_menu", "Epic Menu Screen!!!", {
  {
    text="PLAY", system="character_selection_menu"
  },
  {
    text="CREDITS", system="credits"
  },
  {
    text="DEBUG", system="debug"
  },
  {
    text="EXIT", action=exit
  }
})

-- end menu
