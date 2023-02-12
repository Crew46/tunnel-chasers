---
--- Created by dkienenb.
--- DateTime: 2/10/23 7:21 PM
--- utils
---

button_pushed_table = {}

function trace_table(printed)
  for k, v in pairs(printed) do
    trace(k .. ": " .. v)
  end
end

function print_centered(string, x, y, color)
  local width = print(string, 0, -8)
  print(string, x - (width / 2), y, color or 15)
end

function button_push_util(button)
  if btn(button) and not button_pushed_table[button] then
    button_pushed_table[button] = true
    return true
  end
  if not btn(button) and button_pushed_table[button] then
    button_pushed_table[button] = false
  end
end
-- end utils
