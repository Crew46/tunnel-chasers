---
--- Created by dkienenb.
--- DateTime: 2/14/23 10:59 AM
--- Title splash screen
---

local function render_function()
    gsync(0,1,false)--sync all assets
    gsync(8|16,0)--sync music
    vbank(0)
    play_music(0,0,0,true)
    
    map(15,8.5,15,9,0,0,-1,2)
end

make_splash_system("title", "main_menu", render_function, 13)
--end title
