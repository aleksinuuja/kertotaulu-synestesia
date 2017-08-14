sound1index = 0
sound2index = 0
gameStates.maingame = {}
s = gameStates.maingame -- short ref to maingame state
s.isInitiated = false

require "ticker"
require "button"
require "question"

function gameStates.maingame.initiateState()
  s.resetGame()
end

function s.resetGame()
  s.isPaused = false
  isFeedback = false
  score = 0
  feedBackTime = 0
  showFirstColour = false
  showSecondColour = false
  colour1 = {140, 200, 240, 255}
  colour2 = {250, 200, 240, 255}
  colour3 = {140, 200, 240, 255}
  colour4 = {250, 200, 240, 255}
  sound1index = 0
  sound2index = 0
  sound3index = 0
  sound4index = 0
  allButtons = {}
  allQuestions = {}
  show2Questions = true
  waitingForClick = false
  alreadyClicked = false
  verbalFeedbackSet = false
  feedbackIndex = 1

  local font = love.graphics.newFont("graphics/Krungthep.ttf", 56)
  feedbackText = love.graphics.newText(font, "") -- this is used to show the correct answer
  feedbackNext = love.graphics.newText(font, "blä") -- this is used to show verbal feedback
  feedbackNum1 = love.graphics.newText(font, "1") -- not used
  feedbackNum2 = love.graphics.newText(font, "2") -- not used

  font = love.graphics.newFont("graphics/Krungthep.ttf", 20)
  feedbackNext2 = love.graphics.newText(font, "blä") -- this is used to show "click next"
  scoreText = love.graphics.newText(font, tostring(score))

  question = Question:new({
    x = love.graphics.getWidth() * 1/4,
    y = love.graphics.getHeight() * 3/6,
    width = 400,
    height = 90,
    valueA = "",
    valueB = "",
    isMainQuestion = true
  })
  table.insert(allQuestions, question)
  question2 = Question:new({
    x = love.graphics.getWidth() * 1/4,
    y = love.graphics.getHeight() * 3/6 + 75,
    width = 400,
    height = 90,
    valueA = "",
    valueB = "",
    isMainQuestion = false
  })
  table.insert(allQuestions, question2)

  responseButton1 = Button:new({
    x = love.graphics.getWidth() * 3/5,
    y = love.graphics.getHeight() * 2/6,
    width = 150,
    height = 90,
    value = "24" -- number as a string - convert when comparing
  })
  table.insert(allButtons, responseButton1)

  responseButton2 = Button:new({
    x = love.graphics.getWidth() * 3/5,
    y = love.graphics.getHeight() * 3/6,
    width = 150,
    height = 90,
    value = "27" -- number as a string - convert when comparing
  })
  table.insert(allButtons, responseButton2)

  responseButton3 = Button:new({
    x = love.graphics.getWidth() * 3/5,
    y = love.graphics.getHeight() * 4/6,
    width = 150,
    height = 90,
    value = "49" -- number as a string - convert when comparing
  })
  table.insert(allButtons, responseButton3)

  function onTick()
    if feedBackTime > 0 then feedBackTime = feedBackTime -1 end
    if isFeedback then
      if feedBackTime == 4 then
        feedbackNext:set("")
        feedbackNext2:set("")
        score = score + 1
        scoreText = love.graphics.newText(font, tostring(score))
        showFirstColour = true
        if question.showAFirst then question.showAColour = true else question.showBColour = true end
        audio.Note[audioChannel][sound1index]:stop()
    		audio.Note[audioChannel][sound1index]:setVolume(0.5)
    		audio.Note[audioChannel][sound1index]:play()
        audioChannel = audioChannel + 1; if audioChannel > 2 then audioChannel = 1 end
        if show2Questions then -- special case two questions and two sounds
          if question2.showAFirst then question2.showAColour = true else question2.showBColour = true end
          audio.Note[audioChannel+2][sound3index]:stop()
      		audio.Note[audioChannel+2][sound3index]:setVolume(0.5)
      		audio.Note[audioChannel+2][sound3index]:play()
        end
      elseif feedBackTime == 2 then
        showSecondColour = true
        if question.showAFirst then question.showBColour = true else question.showAColour = true end
        question.showBColour = true -- ??????
        audio.Note[audioChannel][sound2index]:stop()
    		audio.Note[audioChannel][sound2index]:setVolume(0.5)
    		audio.Note[audioChannel][sound2index]:play()
        audioChannel = audioChannel + 1; if audioChannel > 2 then audioChannel = 1 end
        if show2Questions then -- special case two questions and two sounds
          if question2.showAFirst then question2.showBColour = true else question2.showAColour = true end
          question2.showBColour = true -- ??????
          audio.Note[audioChannel+2][sound4index]:stop()
      		audio.Note[audioChannel+2][sound4index]:setVolume(0.5)
      		audio.Note[audioChannel+2][sound4index]:play()
        end
      elseif feedBackTime == 0 then
        if not(verbalFeedbackSet) then
          feedbackNext:set(newFeedback())
          feedbackNext2:set("Klikkaa seuraavaan")
          verbalFeedbackSet = true
        end
        waitingForClick = true
        if alreadyClicked == true then
          alreadyClicked = false
          waitingForClick = false
          verbalFeedbackSet = false
          isFeedback = false
          showFirstColour = false
          showSecondColour = false
          question.showAColour = false
          question.showBColour = false
          question2.showAColour = false
          question2.showBColour = false
          question:newQuestion()
          question2:newQuestion()
        end
      end
    end
  end
  theTicker = Ticker:new({tickFunction = onTick})
end

function newFeedback()
  local returnString


  if feedbackIndex == 1 then returnString = "Oikein!"
  elseif feedbackIndex == 2 then returnString = "Taas oikein!"
  elseif feedbackIndex == 3 then returnString = "Hienoa!"
  elseif feedbackIndex == 4 then returnString = "Olet mahtava!"
  elseif feedbackIndex == 5 then returnString = "Oikein!"
  elseif feedbackIndex == 6 then returnString = "Kyllä!"
  elseif feedbackIndex == 7 then returnString = "Mahtavaa!"
  elseif feedbackIndex == 8 then returnString = "Olet ilmiömäinen!"
  elseif feedbackIndex == 9 then returnString = "Aivan oikein!"
  elseif feedbackIndex == 10 then returnString = "Täsmälleen!"
  end
  feedbackIndex = feedbackIndex + 1
  if feedbackIndex > 10 then feedbackIndex = 1 end
  return returnString
end

function gameStates.maingame.draw()
  -- first draw zoomable game graphics
  love.graphics.push()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setLineWidth(1)
  love.graphics.scale(tv("scale"), tv("scale"))
--  love.graphics.translate(tv("sX"), tv("sY"))

  -- draw background image - replaced with a coloured rectangle
--  love.graphics.draw(bg)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth()/tv("scale"), love.graphics.getHeight()/tv("scale"))

  -- Show score
  love.graphics.setColor(50, 50, 50)
  love.graphics.draw(scoreText, 10, 10)

  if not isFeedback then
    for i,button in ipairs(allButtons) do
      button:draw()
    end
  else
    drawFeedback()
  end
  if show2Questions then question:draw(question.y-30) else question:draw(question.y) end
  if show2Questions then question2:draw(question2.y-30) end

  -- then reset transformations and draw static overlay graphics such as texts and menus
  love.graphics.pop()

--  love.graphics.setColor(255, 255, 255)
--  love.graphics.print("Current FPS: " .. tostring(currentFPS), love.graphics.getHeight()+10, 10)
end

function drawFeedback()

  if not(show2Questions) then
    -- colours
    if showFirstColour then
      love.graphics.setColor(colour1)
      love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight()/2+30, 5, 5)
    end

    if showSecondColour then
      love.graphics.setColor(colour2)
      love.graphics.rectangle("fill", 0, love.graphics.getHeight()/2+30, love.graphics.getWidth(), love.graphics.getHeight()/2-30, 5, 5)
    end
  else
    -- special cases 12, 24, 36 show 4 colours!
    if showFirstColour then
      love.graphics.setColor(colour1)
      love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth()/2, love.graphics.getHeight()/2+30, 5, 5)
    end

    if showFirstColour then
      love.graphics.setColor(colour3)
      love.graphics.rectangle("fill", love.graphics.getWidth()/2, 0, love.graphics.getWidth()/2, love.graphics.getHeight()/2+30, 5, 5)
    end

    if showSecondColour then
      love.graphics.setColor(colour2)
      love.graphics.rectangle("fill", 0, love.graphics.getHeight()/2+30, love.graphics.getWidth()/2, love.graphics.getHeight()/2-30, 5, 5)
    end

    if showSecondColour then
      love.graphics.setColor(colour4)
      love.graphics.rectangle("fill", love.graphics.getWidth()/2, love.graphics.getHeight()/2+30, love.graphics.getWidth()/2, love.graphics.getHeight()/2-30, 5, 5)
    end

  end

  -- textual feedback
  love.graphics.setColor(50, 50, 50)
  love.graphics.draw(feedbackNext, love.graphics.getWidth()*1/4, love.graphics.getHeight()*2/3)
  love.graphics.draw(feedbackNext2, love.graphics.getWidth()*1/4, love.graphics.getHeight()*2/3+70)

  --[[
  local darkercolour = {}

  -- feedback numbers
  if showFirstColour then
    darkercolour[1] = colour1[1] * 1/2
    darkercolour[2] = colour1[2] * 1/2
    darkercolour[3] = colour1[3] * 1/2
    love.graphics.setColor(darkercolour)
    love.graphics.draw(feedbackNum1, love.graphics.getWidth()*2/4, 20, 0, 5, 5)
  end

  if showSecondColour then
    darkercolour[1] = colour2[1] * 1/2
    darkercolour[2] = colour2[2] * 1/2
    darkercolour[3] = colour2[3] * 1/2
    love.graphics.setColor(darkercolour)
    love.graphics.draw(feedbackNum2, love.graphics.getWidth()*2/4, love.graphics.getHeight()*6/10, 0, 5, 5)
  end
]]--


  -- box behind text
  love.graphics.setColor(50, 50, 50)
  love.graphics.setLineWidth(5)
  love.graphics.rectangle("line", love.graphics.getWidth()*1/5+10, love.graphics.getHeight()*2/5+50, love.graphics.getWidth()*2/5, love.graphics.getHeight()*1/5-20, 5, 5)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", love.graphics.getWidth()*1/5+10, love.graphics.getHeight()*2/5+50, love.graphics.getWidth()*2/5, love.graphics.getHeight()*1/5-20, 5, 5)


  -- Feedback text
  love.graphics.setColor(50, 50, 50)
  love.graphics.draw(feedbackText, love.graphics.getWidth()*2/4-100, love.graphics.getHeight()*2/4)


end


function gameStates.maingame.mousepressed(x, y, button)
  x = x / tv("scale")
  y = y / tv("scale")
  if button == 1 then
    if waitingForClick then alreadyClicked = true
    elseif not isFeedback then
      -- check all buttons if they hit, if yes print their value
      for i,b in ipairs(allButtons) do
        if x > b.x and x < b.x + b.width
        and y > b.y and y < b.y + b.height
        then
          if not(b.isDisabled) then
            if b.correct then
              print("is correct!")
              isFeedback = true
              feedBackTime = 5 -- how many ticks we show this (time also used to trigger colour and sound)
              feedbackText:set(b.value)
            else
              b.isDisabled = true
            end
          end
        end
      end
      theTicker:forceTickNow()
    end
  end
end

function gameStates.maingame.mousereleased(x, y, button)
  if button == 1 then

  end
end

function gameStates.maingame.keypressed(key)
  if key == "space" then
    s.isPaused = not(s.isPaused) -- switch pause on and off
  end
end

function gameStates.maingame.update(dt)
  if not isInitiated then
    isInitiated = true
    gameStates.maingame.initiateState()
    tweenEngine:createTween("scale", 2, 1, 0.5, linearTween)
  end

  if not s.isPaused then
    theTicker:update()
    for i,q in ipairs(allQuestions) do
      q:update()
    end

--    theTicker.tickDuration = (1000 - timeScaleSlider.value) / 1000
  end -- is not paused
end


-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

-- return 'v' rounded to 'p' decimal places:
function round(v, p)
local mult = math.pow(10, p or 0) -- round to 0 places when p not supplied
    return math.floor(v * mult + 0.5) / mult;
end
