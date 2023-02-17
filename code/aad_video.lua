---
--- Created by dkienenb.
--- DateTime: 2/13/23 11:04 AM
--- Video rendering system (for cutscenes, credits, and the like)
---

function make_video_system(name, init_function, frame_function, ticks_per_frame, frame_count, next_system)
  local function video_init()
    tick = 0
    video_frame = 0
    init_function()
  end

  local function video_loop()
    if btnp(5) then
      current_system = next_system
    end
    if (tick % ticks_per_frame) == 0 then
      if (video_frame == frame_count) then
        current_system = next_system
      else
        video_frame = video_frame + 1
        frame_function(video_frame)
      end
      if video_frame == 1 then
        print_centered("(Press " .. button_to_string(5) .." to skip)", 195, 125)
      end
    end
    tick = tick + 1
  end
  make_system(name, video_init, video_loop)
end

-- end video renderer
