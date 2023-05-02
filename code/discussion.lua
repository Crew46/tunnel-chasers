---
--- Created by dkienenb.
--- DateTime: 2/15/23 11:27 AM
--- Discussion "combat" system

function discussion_init()
  gsync(0,2,false)
  gsync(32,0,false)

  officer_result = nil
  if not progression then
    progression = {}
  end

  local function make_question(names)
    local question_text = names[math.random(#names)]
    local question = { question_text = question_text, responses = {}, add_response = function(self, response_text, truthfulness, effectiveness, incrimination, ridiculousness)
      table.insert(self.responses, { response_text = response_text, truthfulness = truthfulness, effectiveness = effectiveness, incrimination = incrimination, ridiculousness = ridiculousness })
      return self
    end }
    return question
  end
  local function test_progression(progression_requirements)
    for _, requirement in ipairs(progression_requirements) do
      if not (progression and progression[requirement]) then
        return false
      end
    end
    return true
  end

  local function add_question(names, progression_requirements)
    local question = make_question(names)
    if not progression_requirements or test_progression(progression_requirements) then
      table.insert(questions, question)
    end
    return question
  end
  local threshold = 10
  officer_trust = 3
  incrimination_threshold = threshold
  effectiveness_threshold = threshold
  balance_threshold = math.sqrt(threshold)
  questions = {}
  chosen_responses = {}
  add_question({ "Who are you?" })
          :add_response("Your mom", 1, 5, 2, 6)
          :add_response("A criminal", 3, 1, 5, 2)
          :add_response("A student", 4, 3, 2, 1)
          :add_response("A student, doing some exploration", 5, 2, 3, 2)

  add_question({ "What are you doing here?", "What are you hoping to accomplish here?", "Why are you here?" })
          :add_response("Looking for the restrooms", 1, 4, 3, 2)
          :add_response("Sorry, I'm a new student and got lost", 1, 3, 3, 3)
          :add_response("I'm here for something relating to my work study", 1, 5, 1, 4)
          :add_response("It's a club thing", 1, 4, 2, 3)
          :add_response("You'll never catch me!", 4, 1, 4, 1)
          :add_response("Saving orphan children from crocodiles", 1, 5, 1, 5)
          :add_response("Exploring", 5, 3, 3, 2)
          :add_response("Breaking into the tunnels", 5, 1, 3, 3)
          :add_response("Stealing things and selling them", 1, 1, 5, 3)
          :add_response("Looking for the exit", 1, 3, 3, 3)
          :add_response("Getting some homework done", 3, 4, 2, 2)
          :add_response("Making money off of stolen goods", 1, 1, 5, 3)
          :add_response("I'm not here", 1, 5, 2, 5)
          :add_response("Gathering supplies for a zombie apocalypse", 1, 5, 1, 5)
          :add_response("Helping a Nigerian price regain his kingdom", 1, 5, 1, 5)
          :add_response("Exploring the tunnels", 1, 2, 4, 2)

  add_question({ "Why did you drop-kick that orphan?" }, { "orphan_kick" })
          :add_response("Self-defense", 5, 5, 5, 3)
          :add_response("Attack mode", 2, 1, 5, 3)
          :add_response("I think Jerry did it", 1, 4, 2, 4)
          :add_response("Me? I would never", 1, 5, 1, 2)

  add_question({ "How'd you get in? The doors are locked." }, { "lockpick" })
          :add_response("No they weren't", 1, 2, 2, 5)
          :add_response("Magic", 1, 3, 2, 5)
          :add_response("Don't you remember? You let me in", 1, 5, 2, 4)
          :add_response("I picked the lock", 5, 2, 5, 1)
          :add_response("To be honest I don’t know. How did you get here?", 1, 3, 3, 5)
          :add_response("I am a federal agent on a secret mission to save the president", 1, 2, 5, 4)

  add_question({"What is your favorite hobby?"})
          :add_response("Tax fraud", 2, 2, 5, 3)
          :add_response("Hacking government computers", 2, 1, 5, 4)
          :add_response("Making videogames", 5, 3, 1, 2)
          :add_response("Cheating on exams", 2, 2, 4, 2)
          :add_response("Playing chess", 5, 4, 1, 2)
          :add_response("Exploring", 5, 3, 3, 1)

  function load_question(question)
    if not question then
      local number_of_questions = #questions
      if not selected_question and number_of_questions > 0 and not officer_result then
        local question_index = math.random(number_of_questions)
        selected_question = table.remove(questions, question_index)
        timer = player.acuity * 60
      end
      if number_of_questions <= 0 then
        officer_result = "discussion_neutral"
      end
    else
      selected_question = question
      timer = player.acuity * 60
    end
  end

  function load_responses()
    if selected_question and not selected_question.selected_responses then
      local responses = selected_question.responses
      local selected_responses = {}
      local function add_action_response(list, response_text, effectiveness, incrimination, button)
        table.insert(list, { response_text = response_text, truthfulness = 4, effectiveness = effectiveness, incrimination = incrimination, ridiculousness = -5, button = button })
      end
      add_action_response(selected_responses, "*silence*", 1, 2, 0)
      add_action_response(selected_responses, "*flee*", 1, 5, 1)
      for index = 1, player.ingenuity do
        local count = #responses
        if count < 1 then
          break
        end
        local response_index = math.random(count)
        local response = table.remove(responses, response_index)
        response.button = index + 1
        table.insert(selected_responses, response)
      end
      selected_question.selected_responses = selected_responses;
    end
  end

  function check_ridiculousness(response)
    local d00 = math.random(100)
    d00 = d00 - math.max(player.charisma * player.honesty, 0)
    local effective_ridiculousness = response.ridiculousness - (player.charisma - 1)
    if effective_ridiculousness < 1 then
      effective_ridiculousness = 1
    end
    local d00_threshold = ({ 100, 75, 50, 25, 10 })[effective_ridiculousness] or 0
    if d00 > d00_threshold then
      response.effectiveness = 0
      response.incrimination = 0
      officer_trust = officer_trust - 1
      local question = make_question({ "I don't believe you!" })
              :add_response("But it's true!", response.truthfulness, response.effectiveness, response.incrimination, response.ridiculousness + 1)
      load_question(question)
      return false
    else
      return true
    end
  end

  function answer_question(question, response)
    if not response then
      local response_index = math.random(#(question.selected_responses))
      response = table.remove(question.selected_responses, response_index)
    end
    player.honesty = player.honesty + (response.truthfulness - 4)
    if check_ridiculousness(response) then
      table.insert(chosen_responses, response)
    end
    if question == selected_question then
      selected_question = nil
    end
  end

  function select_choice()
    local current_question = selected_question
    for i = 0, 31 do
      if btnp(i) and current_question then
        for _, response in ipairs(current_question.selected_responses) do
          if response.button == i then
            answer_question(current_question, response)
          end
        end
      end
    end
  end

  function get_stats()
    local effectiveness = player.charisma
    local incrimination = 0
    local fled = false
    for _, response in ipairs(chosen_responses) do
      effectiveness = effectiveness + response.effectiveness
      incrimination = incrimination + response.incrimination
      if response.response_text == "*flee*" then
        fled = true
      end
    end
    local effectiveness_threshold_reached = effectiveness >= effectiveness_threshold
    local incrimination_threshold_reached = incrimination >= incrimination_threshold
    local balanced_stats = math.abs(effectiveness - incrimination) <= balance_threshold
    return effectiveness, incrimination, effectiveness_threshold_reached, incrimination_threshold_reached, balanced_stats, fled
  end

  function check_thresholds()
    if not officer_result then
      local _, _, effectiveness_threshold_reached, incrimination_threshold_reached, balanced_stats, fled = get_stats()
      if effectiveness_threshold_reached or incrimination_threshold_reached then
        if fled then
          current_system = "looping_runner"
        elseif incrimination_threshold_reached then
          officer_result = "discussion_fail"
        elseif balanced_stats then
          officer_result = "discussion_neutral"
        else
          officer_result = "discussion_success"
        end
      end
      if officer_trust <= 0 then
        officer_result = "discussion_fail"
      end
    end
    if officer_result == "discussion_fail" then
      current_system = "continue_menu_splash"
    end
    if officer_result == "discussion_neutral" or officer_result == "discussion_success" then
      current_system = "interior_level"
    end
  end

  function timer_tick()
    timer = timer - 1
    if timer <= 0 and selected_question then
      answer_question(selected_question)
    end
  end

  function discussion_logic_loop()
    load_question()
    load_responses()
    timer_tick()
    select_choice()
    check_thresholds()
  end

  function print_question(question, color)
    print_centered(question.question_text, 121, 8, color or 9)
    print_centered(question.question_text, 120, 7, color or 11)
    if question.selected_responses then
      for i = 1, #question.selected_responses do
        local response = question.selected_responses[i]
        -- todo color these dynamically depending on their stats
        print_centered("(" .. button_to_string(response.button) .. ") " .. response.response_text, 121, 8 + (10 * i), color or 7)
        print_centered("(" .. button_to_string(response.button) .. ") " .. response.response_text, 120, 7 + (10 * i), color or 5)
      end
    end
  end

  function discussion_graphics_loop(color)
    if selected_question then
      print_question(selected_question,color)
    end
    if timer and timer > 0 then print((timer // 60) + 1, 80, 0, color or 12) end
  end

  function makingItPretty()
    vbank(0)
    map(30,17,240,136,0,0,-1)
    map(60,00,240,136,0,3,0,2)
  
    vbank(1)
    poke(0x03FF8,0)
    map(30,17,240,136,0,0,-1)
    map(60,00,240,136,0,3,0,2)
    
    spr(461,64,35,5,2,0,0,1,1)--light
    spr(461,160,35,5,2,0,0,1,1)--light
    spr(430,48,49,5,3,0,0,2,3)--spotlight
    spr(430,144,49,5,3,0,0,2,3)--spotlight
      
    vbank(0)
    spr(445,158,102,5,2,1,0,1,1)--shadow officer
    spr(445,164,102,5,2,1,0,1,1)--shadow officer
    spr(445,61,102,5,2,1,0,1,1)--shadow pc
    spr(480,154,78,0,2,1,0,2,2)--officer
    spr(pc.spr_Id_h,55,78,pc.CLRK,2,pc.flip,0,2,2)--pc
    discussion_graphics_loop()

    vbank(1)
    map(180,134,240,136,0,120,0)
  end
end

function discussion_loop()
  cls()
  makingItPretty()
  discussion_logic_loop()
  discussion_graphics_loop(0)
end

make_system("discussion", discussion_init, discussion_loop)
-- end discussion
