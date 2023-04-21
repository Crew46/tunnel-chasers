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

--[[
	gsync():
		sync a section multiple times per frame.

	mask - REQUIRED:
		mask of section you want to switch...

		tiles   = 1<<0 -- 1
		sprites = 1<<1 -- 2
		map     = 1<<2 -- 4
		sfx     = 1<<3 -- 8
		music   = 1<<4 -- 16
		palette = 1<<5 -- 32
		flags   = 1<<6 -- 64
		screen  = 1<<7 -- 128
	bank - REQUIRED:
		memory bank (0..7)
	tocart - OPTIONAL:
		true... save memory from runtime to bank/cartridge.
		false... load data from bank/cartridge to runtime.

	remarks:
		functions very similarly to `sync()` function without
		restriction of one call per frame.

	author:
		khuxkm
	license:
		MIT License
]]--
local gsync = (function()
	-- defining where we store bank data
	local banks = {}
	for index = 0, 7 do banks[index] = {} end

	--[[
		peeks():
			allows reading directly from RAM, specifically multiple
			data at once.

		addr - REQUIRED:
			the address of RAM you desire to read.
		size - REQUIRED:
			size of data you desire to read in RAM.

		returns:
			data read from RAM.
	]]--
	local function peeks(addr, size)
		local addr = addr
		local data = ""

		for i = 1, size do
			data = data..(string.char(peek(addr)))
			addr = addr + 1
		end
		return data
	end
	--[[
		pokes():
			allows writing directly to RAM, specifically multiple
			data at once.

		addr - REQUIRED:
			the address of RAM you desire to write.
		val  - REQUIRED:
			byte array of values to write to RAM.
	]]--
	local function pokes(addr, val)
		local addr = addr

		for index = 1, #val do
			poke(addr, val:byte(index))
			addr = addr + 1
		end
	end
	--[[
		_G.vbank():
			allows switching to different bank of VRAM.

		id:
			the VRAM bank ID to switch to (0..1)
	]]--
	local _vbank = vbank
	local cur_vbank = 0
	function _G.vbank(id)
		_vbank(id)
		cur_vbank = id & 1
	end
	--[[
		defbank():
			reads and stores a loaded memory bank's contents
			into the appropriate location in the `banks` table.

		bank - REQUIRED:
			memory bank (0..7)
		mask - OPTIONAL (DEFAULT 255):
			mask of sections you want to read and store...

			tiles   = 1<<0 -- 1
			sprites = 1<<1 -- 2
			map     = 1<<2 -- 4
			sfx     = 1<<3 -- 8
			music   = 1<<4 -- 16
			palette = 1<<5 -- 32
			flags   = 1<<6 -- 64
			screen  = 1<<7 -- 128
	]]--
	local function defbank(bank, mask)
		-- if mask is nil then it is set to 255
		mask = mask or 255

		-- checking what flags were set in mask and storing
		-- appropriate information from memory
		if (mask & 1 ) > 0 then banks[bank].tiles   = peeks(0x4000,  8192        ) end
		if (mask & 2 ) > 0 then banks[bank].sprites = peeks(0x6000,  8192        ) end
		if (mask & 4 ) > 0 then banks[bank].map     = peeks(0x8000,  240   * 136 ) end
		if (mask & 8 ) > 0 then banks[bank].sfx     = peeks(0xffe4,  256   + 4224) end
		if (mask & 16) > 0 then banks[bank].music   = peeks(0x11164, 11520 + 408 ) end
		if (mask & 32) > 0 then
			-- palettes are a special case since we want to store
			-- both vbanks
			_vbank(0)
			banks[bank].palette  = peeks(0x3fc0, 48)
			_vbank(1)
			banks[bank].palette1 = peeks(0x3fc0, 48)
			_vbank(cur_vbank)
		end
		if (mask & 64 ) > 0 then banks[bank].flags  = peeks(0x14404, 512  ) end
		if (mask & 128) > 0 then banks[bank].screen = peeks(0x00,    16320) end
	end
	--[[
		setbank():
			reads a chosen memory bank's contents to write
			into active memory to switch active memory bank.

		bank - REQUIRED:
			memory bank (0..7)
		mask - OPTIONAL (DEFAULT 255):
			mask of sections you want to switch...

			tiles   = 1<<0 -- 1
			sprites = 1<<1 -- 2
			map     = 1<<2 -- 4
			sfx     = 1<<3 -- 8
			music   = 1<<4 -- 16
			palette = 1<<5 -- 32
			flags   = 1<<6 -- 64
			screen  = 1<<7 -- 128
	]]--
	local function setbank(bank, mask)
		-- if mask is nil then it is set to 255
		mask = mask or 255

		-- checking what flags were set in mask and writing
		-- appropriate information to memory
		if (mask & 1 ) > 0 then pokes(0x4000,  banks[bank].tiles  ) end
		if (mask & 2 ) > 0 then pokes(0x6000,  banks[bank].sprites) end
		if (mask & 4 ) > 0 then pokes(0x8000,  banks[bank].map    ) end
		if (mask & 8 ) > 0 then pokes(0xffe4,  banks[bank].sfx    ) end
		if (mask & 16) > 0 then pokes(0x11164, banks[bank].music  ) end
		if (mask & 32) > 0 then
			-- palettes are a special case since we want to write
			-- to both vbanks
			_vbank(0)
			pokes(0x3fc0,banks[bank].palette)
			_vbank(1)
			pokes(0x3fc0,banks[bank].palette1)
			_vbank(cur_vbank)
		end
		if (mask & 64 ) > 0 then pokes(0x14404, banks[bank].flags ) end
		if (mask & 128) > 0 then pokes(0x00,    banks[bank].screen) end
	end
	--[[
		ret.load():
			Defines (reads/stores) banks for later use.

		fun - OPTIONAL:
			A function to within temporary `TIC()` while gsync loads
			banks. Defaults to a homemade "Loading" screen.

		remarks:
			Call this function after you define your `TIC()` function; once
			`gsync()` finishes loading, control will be returned to your `TIC()`.
	]]--
	local _sync = sync
 	local ret = {}
	function ret.load(fun)
		-- if the given function is nil, we utilize a default
		-- loading screen function
		fun = fun or function(n)
			cls()
			local s = "Loading"..(("."):rep(n))
			local _w = print(s, 0, -6)
			print(s, (240//2)-(_w//2), 65)
		end

		-- keeps track of `TIC()` function and bank number
		local T = _G.TIC
		local bank = 0
		-- what acts as a temporary `TIC()` function
		function _G.TIC()
			-- done loading banks, returning back to user's main
			-- `TIC()` function.
			if bank == 8 then sync(0,0,false) _G.TIC = T return T() end

			-- syncing to desired bank, storing its data and saving its
			-- pallete to vbank0
			sync(0, bank, false)
			defbank(bank)
			vbank(0)
			pokes(0x3fc0, banks[0].palette)

			-- updating loading screen, incrementing what
			-- bank we are working with
			fun(bank)
			bank = bank + 1
		end
	end
	--[[
		ret.sync():
			Sync sections to or from the cartridge.

		remarks:
			Comment summary for this function is very similar to
			comment summary for main `gsync()` function/variable
			found as the parent container to all functions/variables
			for `gsync()`.

		author comments:
			Unlike default `sync()`, you can sync a section from the
			cart multiple times per frame. However, when syncing TO
			the cart, you can only do that once per frame (since that
			requires a call to sync). I could probably find a way
			around that but I don't feel like it.
	]]--
	function ret.sync(mask, bank, tocart)
		-- what parameters default to if nil
		mask   = mask or 0
		bank   = bank or 0
		tocart = tocart or false

		-- zero mask will default to complete mask
		if mask == 0 then mask = 255 end

		-- handling tocart parameter
		if tocart then
			-- define bank
			defbank(bank, mask)
			-- call through to tic_api_sync
			return _sync(mask, bank, tocart)
		end

		-- tocart is false so load us up
		setbank(bank, mask)
	end

	-- calling gsync(...) is the same as calling gsync.sync(...)
	return setmetatable(ret, {__call = function(t, mask, bank, tocart) return t.sync(mask, bank, tocart) end})
end)()

-- end utils
