---
--- Coded by dkienenb and AshBC.
--- DateTime: 2/13/23 12:00 PM
--- Intro subsystem
---

function intro_init()
  intro_frames = {
    {
      text="Lab46",
      color=3
    },
    {
      text="CCC",
      color=1
    },
    {
      text="Crew46",
      color=12
    },
    {
      text="Tunnel Chasers",
      color=0
    }
  }
end

function intro_frame(frame)
  cls(13)
  gsync(1|2|4|32,1,false)
  local display = intro_frames[frame]
  if display.text == "CCC" then
    draw("title_screen",frame,0,0,2)
  elseif display.text == "Lab46"  then
    draw("title_screen",frame,0,0,2)
  elseif display.text == "Crew46" then
    draw("title_screen",frame,55,44,2)
  else
    print_centered(display.text, 240/2, 136/2, display.color)
  end
end

intro_init()

make_video_system("intro", intro_init, intro_frame, 60*3, #intro_frames, "title")
-- end intro
