---
--- Created by dkienenb.
--- DateTime: 2/15/23 11:27 AM
--- Discussion "combat" system

function discussion_init()
  local function add_question(question_text)
    local question = {question_text=question_text, responses={}, add_response = function(question, response_text, truthfulness, effectiveness, incrimination, ridiculousness)
      table.insert(question.responses, {response_text=response_text, truthfulness=truthfulness, effectiveness=effectiveness, incrimination=incrimination, ridiculousness=ridiculousness})
      return question
    end}
    table.insert(questions, question)
    return question
  end
  local threshold = 4
  incrimination_threshold = threshold
  effectiveness_threshold = threshold
  balance_threshold = threshold / 2
  questions = {}
  chosen_responses = {}
  add_question("Example question")
          :add_response("Example response", 1, 1, 1, 1)
          :add_response("Example response 2", 2, 2, 2, 2)
          :add_response("Example response 3", 3, 3, 3, 3)
          :add_response("Example response 4", 4, 4, 4, 4)
  add_question("Example question 2")
          :add_response("Example response", 1, 1, 1, 1)
          :add_response("Example response 2", 2, 2, 2, 2)
          :add_response("Example response 3", 3, 3, 3, 3)
          :add_response("Example response 4", 4, 4, 4, 4)
  add_question("Example question 3")
          :add_response("Effective", 3, 6, 0, 0)
          :add_response("Incriminating", 3, 0, 6, 0)
  -- todo remove debugging statements
  player={ingenuity=2, charisma=2, acuity=5}

  function load_question()
    local number_of_questions = #questions
    if not selected_question and number_of_questions > 0 and not officer_result then
      local question_index = math.random(number_of_questions)
      selected_question = table.remove(questions, question_index)
    end
  end

  function load_responses()
    if selected_question and not selected_question.selected_responses then
      local responses = selected_question.responses
      local selected_responses = {}
      for index = 1, player.ingenuity do
        local response_index = math.random(#responses)
        local response = table.remove(responses, response_index)
        response.button = index - 1
        table.insert(selected_responses, response)
      end
      selected_question.selected_responses = selected_responses;
    end
  end

  function select_choice()
    for i = 0, 31 do
      if btnp(i) and selected_question then
        for _, response in ipairs(selected_question.selected_responses) do
          if response.button == i then
            table.insert(chosen_responses, response)
            selected_question = nil
          end
        end
      end
    end
  end

  function get_stats()
    local effectiveness = 0
    local incrimination = 0
    for _, response in ipairs(chosen_responses) do
      effectiveness = effectiveness + response.effectiveness
      incrimination = incrimination + response.incrimination
    end
    local effectiveness_threshold_reached = effectiveness >= effectiveness_threshold
    local incrimination_threshold_reached = incrimination >= incrimination_threshold
    local balanced_stats = math.abs(effectiveness - incrimination) <= balance_threshold
    return effectiveness, incrimination, effectiveness_threshold_reached, incrimination_threshold_reached, balanced_stats
  end

  function check_thresholds()
    if not officer_result then
      local _, _, effectiveness_threshold_reached, incrimination_threshold_reached, balanced_stats = get_stats()
      if effectiveness_threshold_reached or incrimination_threshold_reached then
        if incrimination_threshold_reached then
          officer_result = "discussion_fail"
        elseif balanced_stats then
          officer_result = "discussion_neutral"
        else
          officer_result = "discussion_success"
        end
      end
    end
  end

  function discussion_logic_loop()
    load_question()
    load_responses()
    select_choice()
    check_thresholds()
  end

  function print_question(question)
    print_centered(question.question_text, 120, 20, 11)
    for i = 1, #question.selected_responses do
      local response = question.selected_responses[i]
      -- todo color these dynamically depending on their stats
      print_centered("(" .. button_to_string(response.button) .. ") " .. response.response_text, 120, 20 + (10 * i), 13)
    end
  end

  function discussion_graphics_loop()
    cls()
    if selected_question then
      print_question(selected_question)
    end
    local effectiveness, incrimination = get_stats()
    print_centered(effectiveness, 60, 50,10)
    print_centered(incrimination, 60, 60,3)
    print_centered(officer_result, 60, 70)
  end
end

function discussion_loop()
  discussion_logic_loop()
  discussion_graphics_loop()
end

make_system("discussion", discussion_init, discussion_loop)
-- end discussion
