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
  questions = {}
  add_question("Example question")
          :add_response("Example response", 1, 1, 1, 1)
          :add_response("Example response 2", 2, 2, 2, 2)
          :add_response("Example response 3", 3, 3, 3, 3)
          :add_response("Example response 4", 4, 4, 4, 4)
  -- todo remove debugging statements
  player={eloquence=2, charisma=2}
end

function discussion_loop()
  -- todo implement this
  cls(3)
end

make_system("discussion", discussion_init, discussion_loop)
-- end discussion
