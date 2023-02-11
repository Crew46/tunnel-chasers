---
--- Created by dkienenb.
--- DateTime: 2/10/23 7:58 PM
--- Credits subsystem.
---

function credits_init()
    credits = {
        {
            name="Ash Barb",
            titles = {
                "Director",
                "Summarizer of vast amounts of data"
            }
        },
        {
            name="Sashami",
            titles = {
                "Artwork"
            }
        },
        {
            name="Dan Muck",
            titles = {
                "snake_case_enthusiast",
                "old"
            }
        },
        {
            name="David Kienenberger",
            titles = {
                "Administrator",
                "Lead Programmer",
                "Professional gluer-upper-er",
                "Paradox",
                "Engine and framework developer",
                "Credits subsystem",
                "Menu subsystem",
                "Project headhunting",
                "Eating cake with a box cutter"
            }
        },
        {
            name="Dylan whatshisface",
            titles = {
                "Epic soundtracks of doom"
            }
        },
        {
            name="Conor Null",
            titles = {
                "Inspiration"
            }
        },
        {
            name="Matt Haas",
            titles = {
                "Producer"
            }
        }
    }
    credit_index = 1;
end

function credits_logic()
    if button_push_util(3) then
        credit_index = credit_index + 1
    end
    if button_push_util(2) then
        credit_index = credit_index - 1
    end
    credit_size = #credits
    if credit_index < 1 then
        credit_index = 1
    end
    if credit_index > credit_size then
        current_system = "menu"
    end
end

function credits_draw()
    cls(0)
    local credit = credits[credit_index]
    local starting_y = (136 / 2) - 10
    local titles = credit.titles
    starting_y = starting_y - (5 * (#titles + 1))
    print_centered(credit.name, 120, starting_y, 4)
    for index, value in ipairs(titles) do
        print_centered(value, 120, starting_y + (index * 10), 10)
    end
    print_centered("(->)", 120, starting_y + (10 * (#titles + 1)), 3)
end

function credits_tick()
    credits_draw()
    credits_logic()
end

make_system("credits", credits_init, credits_tick)

-- end credits
