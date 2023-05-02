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
        "Summarizer of vast amounts of data",
        "Blamer of poor innocent ticify.jar"
      }
    },
    {
      name = "David Kienenberger",
      titles = {
        "Administrator",
        "Lead Programmer",
        "\"Indeed\" sayer"
      }
    },
    {
      name = "Sashami",
      titles = {
        "Artwork",
        "Level Design",
        "Ambassador to Mexico"
      }
    },
    {
      name="MacklenF",
      titles = {
        "Team member",
        "Character selection menu",
        "Regular contributions"
      }
    },
    {
      name="Cordell H",
      titles = {
        "\"whatever you like honestly I have no idea\"",
        "Sneaking levels",
        "Regular contributions"
      }
    },
    {
      name = "David Kienenberger",
      titles = {
        "Integration specialist",
        "Cartridge gluer",
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
        "Project headhunting",
        "Eating cake with a box cutter"
      }
    },
    {
      name = "Isabella LaFace",
      titles = {
        "Assistant Headhunter",
        "Assistant Composer"
      }
    },
    {
      name = "Dylan whatshisface Holton",
      titles = {
        "Epic soundtracks of doom"
      }
    },
    {
      name = "Dialogue Submission",
      titles = {
        "dkienenb",
        "Nathaniel Clark",
        "Chris B"
      }
    },
    {
      name = "David Kienenberger",
      titles = {
        "Completely unbiased credits system",
      }
    },
    {
      name = "Matt Haas",
      titles = {
        "Producer"
      }
    },
    {
      name = "Conor Null",
      titles = {
        "Inspiration"
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
