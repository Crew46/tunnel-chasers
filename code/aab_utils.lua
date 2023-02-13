---
--- Created by dkienenb.
--- DateTime: 2/10/23 7:21 PM
--- utils
---

function trace_table(printed)
  for k, v in pairs(printed) do
    trace(k .. ": " .. v)
  end
end

function print_centered(string, x, y, color)
  local width = print(string, 0, -80)
  print(string, x - (width / 2), y, color or 15)
end

-- end utils
