---
--- Created by dkienenb.
--- DateTime: 2/14/23 11:35 AM
--- Continue menu

make_system_selector_menu_system("continue_menu", "Continue?", {
  {text="Yes", action=function()
    player.lives = player.lives - 1
    current_system = "interior_level"
  end, validator=function()
    return player and player.lives and player.lives > 0
  end},
  {text="No", system="game_over_splash"}
})

-- end continue menu
