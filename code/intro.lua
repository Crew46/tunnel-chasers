---
--- Created by dkienenb.
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
      text="Crew46 Presents",
      color=12
    }
  }
end

function intro_frame(frame)
  cls(13)
  local display = intro_frames[frame]
  print_centered(display.text, 240/2, 136/2, display.color)
end

intro_init()

make_video_system("intro", intro_init, intro_frame, 60*3, #intro_frames, "title")
-- end intro
