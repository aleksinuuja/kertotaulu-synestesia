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
  feedBackTime = 0
  showFirstColour = false
  showSecondColour = false
  colour1 = {140, 200, 240, 255}
  colour2 = {250, 200, 240, 255}
  sound1index = 0
  sound2index = 0
  allButtons = {}

  local font = love.graphics.newFont("graphics/Krungthep.ttf", 56)
  feedbackText = love.graphics.newText(font, "This is FEEDBACK")
  feedbackNum1 = love.graphics.newText(font, "1")
  feedbackNum2 = love.graphics.newText(font, "2")

  question = Question:new({
    x = love.graphics.getWidth() * 1/4,
    y = love.graphics.getHeight() * 3/6,
    width = 400,
    height = 90,
    value = "" -- number as a string - convert when comparing
  })


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
    question:update() -- no idea why question update is called once a tick, it just initializes

    if feedBackTime > 0 then feedBackTime = feedBackTime -1 end
    if isFeedback then
      if feedBackTime == 4 then
        showFirstColour = true
        audio.Note[audioChannel][sound1index]:stop()
    		audio.Note[audioChannel][sound1index]:setVolume(0.5)
    		audio.Note[audioChannel][sound1index]:play()
        audioChannel = audioChannel + 1; if audioChannel > 2 then audioChannel = 1 end
      elseif feedBackTime == 2 then
        showSecondColour = true
        audio.Note[audioChannel][sound2index]:stop()
    		audio.Note[audioChannel][sound2index]:setVolume(0.5)
    		audio.Note[audioChannel][sound2index]:play()
        audioChannel = audioChannel + 1; if audioChannel > 2 then audioChannel = 1 end
      elseif feedBackTime == 0 then
        isFeedback = false
        showFirstColour = false
        showSecondColour = false
        question:newQuestion()
      end
    end
  end
  theTicker = Ticker:new({tickFunction = onTick})
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

  if not isFeedback then
    for i,button in ipairs(allButtons) do
      button:draw()
    end
  else
    drawFeedback()
  end
  question:draw()

  -- then reset transformations and draw static overlay graphics such as texts and menus
  love.graphics.pop()

--  love.graphics.setColor(255, 255, 255)
--  love.graphics.print("Current FPS: " .. tostring(currentFPS), love.graphics.getHeight()+10, 10)
end

function drawFeedback()

  -- colours
  if showFirstColour then
    love.graphics.setColor(colour1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight()/2+30, 5, 5)
  end

  if showSecondColour then
    love.graphics.setColor(colour2)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight()/2+30, love.graphics.getWidth(), love.graphics.getHeight()/2-30, 5, 5)
  end

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
