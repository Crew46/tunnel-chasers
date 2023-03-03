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

function get_button_table()
  local buttons =  {"down", "left", "right", "z", "x", "a", "s"}
  buttons[0] = "up"
  return buttons
end

function string_to_button(string)
  for button, description in ipairs(get_button_table()) do
    if description and description == string then
      return button
    end
  end
end

function button_to_string(button)
  return get_button_table()[button]
end

-- end utils
