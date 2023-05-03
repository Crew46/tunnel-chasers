---
--- Created by dkienenb.
--- DateTime: 2/10/23 7:58 PM
--- Credits subsystem.
---

function credits_init()
  check_music(5)
  do_once=true

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
      name = "Matt Haas",
      titles = {
        "Producer",
        "Wedge"
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
        "Lead Artist",
        "Artwork",
        "Level Design",
        "Ambassador to Mexico"
      }
    },
    {
      name="MacklenF",
      titles = {
        "Programmer",
        "Team member",
        "Character selection menu",
        "Runner System creator"
      }
    },
    {
      name="Cordell H",
      titles = {
        "Programmer",
        "\"whatever you like honestly I have no idea\"",
        "Sneaking levels",
        "Officer Patrolling System"
      }
    },
    {
      name = "David Kienenberger",
      titles = {
        "Integration specialist",
        "Cartridge gluer",
        "Sock Hands"
      }
    },
    {
      name = "Dan Muck",
      titles = {
        "Programmer",
        "snake_case_enthusiast",
        "old",
        "Learning Commons Tutor",
        "Inventory System"
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
      name = "Paradox",
      titles = {
        "Casting as David Kienenberger",
        "Project headhunting",
        "Eating cake with a box cutter"
      }
    },
    {
      name = "Dylan whatshisface Holton",
      titles = {
        "Lead Composer",
        "Epic soundtracks of doom"
      }
    },
    {
      name = "Kienenberger David",
      titles = {
        "Completely unbiased credits system",
        "Didn't actually do that much"
      }
    },
    {
      name = "Gavin S",
      titles = {
        "Programmer",
        "Hiding Mechanic",
        "Creator of Gallop Run",
        "Decided to work on his own project instead :("
      }
    },
    {
      name = "Kaitlyn Manuszewski",
      titles = {
        "Pixel Artist",
        "Epic title maker",
        "Magic Conch Shell Club Member"
      }
    },
    {
      name = "David K.",
      titles = {
        "This guy again"
      }
    },
    {
      name = "Taylor Hurd",
      titles = {
        "Pixel Artist",
        "Sprite Designer",
        "Roxie Hart and all that jazz"
      }
    },
    {
      name = "Saqib Malik",
      titles = {
        "Programmer",
        "Overworld System",
        "Constantly broke the game",
        "Ghetto door fanatic",
        "Creator of Collectrix"
      }
    },
    {
      name = "Will Alley",
      titles = {
        "Pixel Artist",
        "Joinned the team last minute",
        "Sprite creator"
      }
    },
    {
      name = "Conor Null",
      titles = {
        "Inspiration",
        "The guy who gets you in trouble"
      }
    },
    {
      name = "Dialogue Submission",
      titles = {
        "dkienenb",
        "Nathaniel Clark",
        "Chris B",
        "Conor"
      }
    },
    {
      name = "Dialogue Submission (2)",
      titles = {
        "Emillie",
        "Lex",
        "Amar",
        "Sashami"
      }
    },
    {
      name = "Dialogue Submission (3)",
      titles = {
        "odin jjdd xd",
        "4to mes",
        "Cube",
        "Don martz"
      }
    },
    {
      name = "Dialogue Submission (4)",
      titles = {
        "El mazorcas",
        "Luna",
        "Holey :)",
        "Pacomu"
      }
    },
    {
      name = "Dialogue Submission (5)",
      titles = {
        "Red ear tips ",
        "Chavez ",
        "Moonbeam",
        "mercury"
      }
    },
    {
      name = "Dialogue Submission (6)",
      titles = {
        "Cyborg",
        "Terrain",
        "RodentRacer",
        "Fecin"
      }
    },
    {
      name = "Dialogue Submission (7)",
      titles = {
        "Balit",
        "Claudio Marty ",
        "The causa maric",
        "Michael mclane"
      }
    }
  }

  function credits_avini()
    if do_once then
      gsync(0,0,false)--sync all assets
      gsync(8|16,0)--sync music&sfx
      vbank(0)
      do_once=false
    end
  end

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
    if frame == #credits then musicPlaying=false end
  end
end

function credits_loop(frame)
  credits_avini()
  play_music(5,0,0,true)
  credits_draw(frame)
end

credits_init()

make_video_system("credits", credits_init, credits_loop, 60*3, #credits, "main_menu")

-- end credits
