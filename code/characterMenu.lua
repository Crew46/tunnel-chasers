-- title:	Tunnel Chasers
-- author:  MacklenF
-- desc:   	Character Select Menu prototype
-- script:  lua

function character_menu_init()
	player = {
  		sprNum = 0,

		zero = {
			name 	= "Player Zero",
			skill = "Skill zero"
		},
		
		one = {
			name 	= "Player One",
			skill = "Skill One"
		},
		
		two = {
			name 	= "Player Two",
			skill = "Skill Two"
		},
		
		three = {
			name 	= "Player Three",
			skill = "Skill Three"
		},
		
		four = {
			 name 	= "Player Four",
			skill = "Skill Four"
		}
	}

	charMenu_width = 160	-- for display ref.

	boxSelect = {			-- box for "highlighting" player
		
		x		= 96,	
		y 		= 60,
		width 	= 24,
		height 	= 24,
		color 	=  2,
	
		pos = {
			zero 	= charMenu_width*1/5,
			one			=	charMenu_width*2/5,
			two			=	charMenu_width*3/5,
			three = charMenu_width*4/5,
			four 	= charMenu_width
			}
	}

	function highLight()
		rectb(boxSelect.x, 
		 	boxSelect.y, 
			boxSelect.width, 
			boxSelect.height, 
			boxSelect.color)
	
		if btnp(2) then
			boxSelect.x = boxSelect.x-32
			if (boxSelect.x < 32) then
				boxSelect.x = 32
			end
		end
		if btnp(3) then
			boxSelect.x = boxSelect.x+32
			if (boxSelect.x > 160) then
				boxSelect.x = 160
			end
		end
	end		-- end highLight()

	function character_select()
		if (boxSelect.x == boxSelect.pos.zero and
			btnp(0)) then
				player.sprNum = 0
		end
		if (boxSelect.x == boxSelect.pos.one and
			btnp(0)) then
				player.sprNum = 1
		end
		if (boxSelect.x == boxSelect.pos.two and
			btnp(0)) then
				player.sprNum = 2
		end
		if (boxSelect.x == boxSelect.pos.three and
			btnp(0)) then
				player.sprNum = 3
		end
		if (boxSelect.x == boxSelect.pos.four and
			btnp(0)) then
				player.sprNum = 4
		end
	end		-- end character_choice()

	function draw_character_menu()
		cls()
		rect(0, 0, 240, 136, 12)				-- background
		rect(110, 100, 110, 30, 13) -- info box
		print("Select Character", 30, 24, 8, false, 2)
		print("(UP to select)", 30, 120, 2)				
			-- character sprites
		spr(0, charMenu_width*1/5, 60, -1, 3)
		spr(1, charMenu_width*2/5, 60, -1, 3)
		spr(2, charMenu_width*3/5, 60, -1, 3)
		spr(3, charMenu_width*4/5, 60, -1, 3)
		spr(4, charMenu_width, 60, -1, 3)
	end	-- end draw_character_menu()
		
	function check_select()
	-- check player selection and display info
		if (player.sprNum == 0) then
			print("Name: "..player.zero.name, 116, 106, 12)
			print("Skill: "..player.zero.skill, 116, 120, 12)
		end
		if (player.sprNum == 1) then
			print("Name: "..player.one.name,	116, 106, 12)
			print("Skill: "..player.one.skill,116, 120, 12)
		end
		if (player.sprNum == 2) then
			print("Name: "..player.two.name, 116, 106, 12)		
			print("Skill: "..player.two.skill, 116, 120, 12)
		end
		if (player.sprNum == 3) then
			print("Name: "..player.three.name,	116, 106, 12)
			print("Skill: "..player.three.skill,	116, 120, 12)
		end
		if (player.sprNum == 4) then
			print("Name: "..player.four.name,	116, 106, 12)		
			print("Skill: "..player.four.skill, 116, 120, 12)
		end		
	end -- end check_select()
end -- end character_menu_init()


function character_menu_tick()	
	draw_character_menu()
	highLight()
	character_select()
	check_select()	
end -- end character_menu_tick()

make_system("Character_Menu", character_menu_init, character_menu_tick)

--end character select menu
