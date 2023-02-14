---
--- Created by dkienenb.
--- DateTime: 2/10/23 7:58 PM
--- Credits subsystem.
---

function credits_init()
  credits = {
    {
      name = "Based on a true story",
      titles = {}
    },
    {
      name = "Ash Barb",
      titles = {
        "Director",
        "Summarizer of vast amounts of data"
      }
    },
    {
      name = "Sashami",
      titles = {
        "Artwork"
      }
    },
    {
      name="MacklenF",
      titles = {
        "Team member",
        "Character selection menu"
      }
    },
    {
      name="Cordell H",
      titles = {
        "whatever you like honestly I have no idea",
        "Sneaking levels"
      }
    },
    {
      name = "Dan Muck",
      titles = {
        "snake_case_enthusiast",
        "old"
      }
    },
    {
      name = "David Kienenberger",
      titles = {
        "Administrator",
        "Lead Programmer",
        "Integration specialist",
        "Professional gluer-upper-er",
        "Paradox",
        "Engine and framework developer",
        "Credits subsystem",
        "Menu subsystem",
        "Video subsystems",
        "Splash subsystems",
        "Player format",
        "Project headhunting",
        "Eating cake with a box cutter"
      }
    },
    {
      name = "Dylan whatshisface",
      titles = {
        "Epic soundtracks of doom"
      }
    },
    {
      name = "Conor Null",
      titles = {
        "Inspiration"
      }
    },
    {
      name = "Matt Haas",
      titles = {
        "Producer"
      }
    }
  }

  function credits_draw(frame)
    cls(0)
    local credit = credits[frame]
    local starting_y = (136 / 2)
    local titles = credit.titles
    starting_y = starting_y - (5 * (#titles + 1))
    print_centered(credit.name, 120, starting_y, 4)
    for index, value in ipairs(titles) do
      print_centered(value, 120, starting_y + (index * 10), 10)
    end
  end
end

function credits_loop(frame)
  credits_draw(frame)
end

credits_init()

make_video_system("credits", credits_init, credits_loop, 60*3, #credits, "main_menu")

-- end credits
