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
  incrimination_threshold = 4
  effectiveness_threshold = 4
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
  -- todo remove debugging statements
  player={ingenuity=2, charisma=2, acuity=5}

  function discussion_logic_loop()
    local number_of_questions = #questions
    if not selected_question and number_of_questions > 0 then
      local question_index = math.random(number_of_questions)
      selected_question = table.remove(questions, question_index)
    end
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

  function print_question(question)
    print_centered(question.question_text, 120, 20, 11)
    for i = 1, #question.selected_responses do
      local response = question.selected_responses[i]
      print_centered("(" .. response.button .. ") " .. response.response_text, 120, 20 + (10 * i), 13)
    end
  end

  function discussion_graphics_loop()
    cls()
    if selected_question then
      print_question(selected_question)
    end
  end
end

function discussion_loop()
  discussion_logic_loop()
  discussion_graphics_loop()
end

make_system("discussion", discussion_init, discussion_loop)
-- end discussion
