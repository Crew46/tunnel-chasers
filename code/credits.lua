---
--- Created by dkienenb.
--- DateTime: 2/10/23 7:58 PM
--- Credits subsystem.
---

function credits_init()
    credits = {
        {
            name="Ash Barb",
            title="Director"
        },
        {
            name="Sashami",
            title="Artwork"
        },
        {
            name="Dan Muck",
            title="snake_case_enthusiast"
        },
        {
            name="David \"Paradox\" Kienenberger",
            title="Professional gluer-upper-er"
        },
        {
            name="Dylan whatshisface",
            title="Epic soundtracks of doom"
        },
        {
            name="Matt Haas",
            title="Producer"
        }
    }
    credit_index = 1;
    button_pushed=false
    credit_size = #credits
end

function credits_tick()
    cls(0)
    local credit = credits[credit_index]
    print_centered(credit.name, 120, 44, 4)
    print_centered(credit.title, 120, 54, 10)
    print_centered("(Push ->)", 120, 64, 3)
    if btn(3) and not button_pushed then
        credit_index = credit_index + 1
        button_pushed = true
    end
    if not btn(3) and button_pushed then
        button_pushed = false
    end
    credit_size = #credits
    credit_size = #credits
    if credit_index > credit_size then
        current_system = "menu"
    end
end

make_system("credits", credits_init, credits_tick)

-- end credits
