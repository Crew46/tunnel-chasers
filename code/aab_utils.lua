---
--- Created by dkienenb, AshBC, SM.
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

-- author: khuxkm
-- license: MIT License
gsync = (function()
	local banks = {}
	for index = 0, 7 do banks[index] = {} end
	local function peeks(addr, size)
		local addr = addr
		local data = ""

		for i = 1, size do
			data = data..(string.char(peek(addr)))
			addr = addr + 1
		end
		return data
	end
	local function pokes(addr, val)
		local addr = addr

		for index = 1, #val do
			poke(addr, val:byte(index))
			addr = addr + 1
		end
	end
	local _vbank = vbank
	local cur_vbank = 0
	function _G.vbank(id)
		_vbank(id)
		cur_vbank = id & 1
	end
	local function defbank(bank, mask)
		mask = mask or 255
		if (mask & 1 ) > 0 then banks[bank].tiles   = peeks(0x4000,  8192        ) end
		if (mask & 2 ) > 0 then banks[bank].sprites = peeks(0x6000,  8192        ) end
		if (mask & 4 ) > 0 then banks[bank].map     = peeks(0x8000,  240   * 136 ) end
		if (mask & 8 ) > 0 then banks[bank].sfx     = peeks(0xffe4,  256   + 4224) end
		if (mask & 16) > 0 then banks[bank].music   = peeks(0x11164, 11520 + 408 ) end
		if (mask & 32) > 0 then
			_vbank(0)
			banks[bank].palette  = peeks(0x3fc0, 48)
			_vbank(1)
			banks[bank].palette1 = peeks(0x3fc0, 48)
			_vbank(cur_vbank)
		end
		if (mask & 64 ) > 0 then banks[bank].flags  = peeks(0x14404, 512  ) end
		if (mask & 128) > 0 then banks[bank].screen = peeks(0x00,    16320) end
	end
	local function setbank(bank, mask)
		mask = mask or 255
		if (mask & 1 ) > 0 then pokes(0x4000,  banks[bank].tiles  ) end
		if (mask & 2 ) > 0 then pokes(0x6000,  banks[bank].sprites) end
		if (mask & 4 ) > 0 then pokes(0x8000,  banks[bank].map    ) end
		if (mask & 8 ) > 0 then pokes(0xffe4,  banks[bank].sfx    ) end
		if (mask & 16) > 0 then pokes(0x11164, banks[bank].music  ) end
		if (mask & 32) > 0 then
			_vbank(0)
			pokes(0x3fc0,banks[bank].palette)
			_vbank(1)
			pokes(0x3fc0,banks[bank].palette1)
			_vbank(cur_vbank)
		end
		if (mask & 64 ) > 0 then pokes(0x14404, banks[bank].flags ) end
		if (mask & 128) > 0 then pokes(0x00,    banks[bank].screen) end
	end
	local _sync = sync
 	local ret = {}
	function ret.load(fun)
		fun = fun or function(n)
			cls()
			local s = "Loading"..(("."):rep(n))
			local _w = print(s, 0, -6)
			print(s, (240//2)-(_w//2), 65)
		end
		local T = _G.TIC
		local bank = 0
		function _G.TIC()
			if bank == 8 then sync(0,0,false) _G.TIC = T return T() end
			sync(0, bank, false)
			defbank(bank)
			vbank(0)
			pokes(0x3fc0, banks[0].palette)
			fun(bank)
			bank = bank + 1
		end
	end
	function ret.sync(mask, bank, tocart)
		mask   = mask or 0
		bank   = bank or 0
		tocart = tocart or false
		if mask == 0 then mask = 255 end
		if tocart then
			defbank(bank, mask)
			return _sync(mask, bank, tocart)
		end
		setbank(bank, mask)
	end
	return setmetatable(ret, {__call = function(t, mask, bank, tocart) return t.sync(mask, bank, tocart) end})
end)()

collisionBox = {
	screenMap = {
		x = 0,
		y = 0
	},
	topY    = 0,
	bottomY = 0,
	leftX   = 0,
	rightX  = 0
}
function collisionbox_positioncheck(point, sweep)
	local sweep = sweep or { }
	local absoluteX = collisionBox.screenMap.x
	local absoluteY = collisionBox.screenMap.y
	if     point == 0 then
		absoluteX = absoluteX + collisionBox.leftX
		absoluteY = absoluteY + collisionBox.topY
		if sweep.wallCheck then
			absoluteX = absoluteX - sweep.wallCheck
		end
		if sweep.roofCheck then
			absoluteY = absoluteY - sweep.roofCheck
		end
	elseif point == 1 then
		absoluteX = absoluteX + collisionBox.rightX
		absoluteY = absoluteY + collisionBox.topY
		if sweep.wallCheck then
			absoluteX = absoluteX + sweep.wallCheck
		end
		if sweep.roofCheck then
			absoluteY = absoluteY - sweep.roofCheck
		end
	elseif point == 2 then
		absoluteX = absoluteX + collisionBox.leftX
		absoluteY = absoluteY + collisionBox.bottomY
		if sweep.wallCheck then
			absoluteX = absoluteX - sweep.wallCheck
		end
		if sweep.roofCheck then
			absoluteY = absoluteY + sweep.roofCheck
		end
	elseif point == 3 then
		absoluteX = absoluteX + collisionBox.rightX
		absoluteY = absoluteY + collisionBox.bottomY
		if sweep.wallCheck then
			absoluteX = absoluteX + sweep.wallCheck
		end
		if sweep.roofCheck then
			absoluteY = absoluteY + sweep.roofCheck
		end
	else
		error("Collisionbox point out-of-bounds.", 2)
	end

	return {absoluteX, absoluteY}
end
function collisionbox_tilecheck(point, sweep)
	local absolutePositions = collisionbox_positioncheck(point, sweep)
	return mget(absolutePositions[1]/8, absolutePositions[2]/8)
end
function collisionbox_flagcheck(flag, point, sweep)
	local tile = collisionbox_tilecheck(point, sweep)
	return fget(tile, flag)
end
function collisionbox_flagchecks(flag, points, sweep)
	local flaggedPoints = { }
	for index = 1, #points do
		if collisionbox_flagcheck(flag, points[index], sweep) then
			table.insert(flaggedPoints, points[index])
		end
	end
	return flaggedPoints
end

-- copy table
-- author: https://stackoverflow.com/a/26367080
function copy(obj, seen)
    if type(obj) ~= 'table' then
        return obj 
    end
    if seen and seen[obj] then
        return seen[obj] 
    end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for key, value in pairs(obj) do 
        res[copy(key, s)] = copy(value, s) 
    end
    return res
end

function playmusic(isPlaying,track,start_frame,rows,loop) 
	if not isPlaying then
		music(track,start_frame or 0,rows or 0,loop or true)
	elseif track==-1 then
		music()
	end
end

-- end utils
