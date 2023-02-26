---
--- Created by dkienenb.
--- DateTime: 2/15/23 11:27 AM
--- Discussion "combat" system

function discussion_init()
  local function add_question(question_text)
    local question = {question_text=question_text, responses={}, add_response = function(self, response_text, truthfulness, effectiveness, incrimination, ridiculousness)
      table.insert(self.responses, {response_text=response_text, truthfulness=truthfulness, effectiveness=effectiveness, incrimination=incrimination, ridiculousness=ridiculousness})
      return self
    end}
    table.insert(questions, question)
    return question
  end
  local threshold = 10
  officer_trust = 3
  incrimination_threshold = threshold
  effectiveness_threshold = threshold
  balance_threshold = math.sqrt(threshold)
  questions = {}
  chosen_responses = {}
  for index = 1, 5 do
    add_question("Question " .. index .. "?")
            :add_response("Effective response", 5, 5, 1, index)
            :add_response("Incriminating response", 5, 1, 5, index)
            :add_response("Neutral response", 5, 1, 1, index)
            :add_response("Double-edged response", 5, 5, 5, index)
  end

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
      for index = 1, pc.ingenuity do
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
            pc.honesty = pc.honesty + (response.truthfulness - 4)
            local d00 = math.random(100)
            d00 = d00 - math.max(pc.charisma * pc.honesty, 0)
            local effective_ridiculousness = response.ridiculousness - (pc.charisma - 1)
            if effective_ridiculousness < 1 then effective_ridiculousness = 1 end
            local d00_threshold = ({ 100, 75, 50, 25, 10})[effective_ridiculousness] or 0
            if d00 > d00_threshold then
              response.effectiveness = 0
              response.incrimination = 0
              officer_trust = officer_trust - 1
              -- todo display message to player informing them that they were not believed
            end
            selected_question = nil
          end
        end
      end
    end
  end

  function get_stats()
    local effectiveness = pc.charisma
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
      if officer_trust <= 0 then
        officer_result = "discussion_fail"
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
    print(effectiveness, 0, 50, 10)
    print(incrimination, 0, 60, 3)
    print(officer_result, 0, 70)
    print(pc.honesty, 0, 80, 2)
    print(officer_trust, 0, 90)
  end
end

function discussion_loop()
  discussion_logic_loop()
  discussion_graphics_loop()
end

make_system("discussion", discussion_init, discussion_loop)
-- end discussion
