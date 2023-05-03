---
--- Created by dkienenb and AshBC.
--- DateTime: 2/14/23 11:14 AM
--- Continue menu splash
---

local function render_function()
    
    gsync(0,0,false)--sync all assets
    gsync(8|16,0)--sync music
    vbank(0)
    check_music(5)
    play_music(musicTrack,0,0,true)
    cls(12)
    print("You've been caught!",15,60,2,false,2)
end

make_splash_system("continue_menu_splash", "continue_menu", render_function, 3)

-- end continue menu
