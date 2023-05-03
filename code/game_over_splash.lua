---
--- Created by dkienenb and AshBC.
--- DateTime: 2/14/23 12:13 PM
--- Game over splash
---

local function render_function()
    gsync(0,0,false)--sync all assets
    gsync(8|16,0)--sync music
    vbank(0)
    check_music(5)
    play_music(musicTrack,0,0,true)
    cls(0)
    print("GAME OVER",45,60,12,false,3)
end

make_splash_system("game_over_splash", "credits", render_function, 3)

-- end gameover
