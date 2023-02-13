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
    if (tick % ticks_per_frame) == 0 then
      video_frame = video_frame + 1
      if (video_frame == frame_count) then
        current_system = next_system
      else
        frame_function(video_frame)
      end
    end
    tick = tick + 1
  end
  make_system(name, video_init, video_loop)
end

-- end video renderer
