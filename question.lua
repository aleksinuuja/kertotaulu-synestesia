Question = {}

function Question:new(params)
  o = {}
  o.x = params.x
  o.y = params.y
  o.height = params.height
  o.width = params.width
  o.valueA = params.valueA
  o.valueB = params.valueB
  o.colourA = {}
  o.colourB = {}

  o.initiated = false

  o.isMainQuestion = params.isMainQuestion

  local font = love.graphics.newFont("graphics/Krungthep.ttf", 56)
  o.textA = love.graphics.newText(font, o.value)
  o.textB = love.graphics.newText(font, o.value)
  o.textMult = love.graphics.newText(font, " · ")
  o.textEqu = love.graphics.newText(font, " = ")

  o.showAColour = false
  o.showBColour = false
  o.showAFirst = false

  setmetatable(o, self)
  self.__index = self
  return o
end

function Question:draw(qy)

  -- Question text
  if self.showAColour then love.graphics.setColor(self.colourA) else love.graphics.setColor(50, 50, 50) end
  love.graphics.draw(self.textA, self.x, qy)

  love.graphics.setColor(50, 50, 50)
  love.graphics.draw(self.textMult, self.x+50, qy)

  if self.showBColour then love.graphics.setColor(self.colourB) else love.graphics.setColor(50, 50, 50) end
  love.graphics.draw(self.textB, self.x+100, qy)

  love.graphics.setColor(50, 50, 50)
  love.graphics.draw(self.textEqu, self.x+150, qy)

end

function Question:update() -- called once a tick (for some reason)
  if not(self.initiated) then
    self.initiated = true
    self:newQuestion()
  end
end

function Question:newQuestion()
  if self.isMainQuestion then
    local a, b, answer1, answer2, answer3
    local ci = math.random(3) -- how manieth question is right
    a = math.random(8) + 1
    b = math.random(8) + 1

    self.colourA = colourForNumber(a)
    self.colourB = colourForNumber(b)

    if a <= b then -- always lower number first for colour and sound
      self.showAFirst = true
      colour1 = colourForNumber(a)
      colour2 = colourForNumber(b)
      sound1index = a-1
      sound2index = b-1
      feedbackNum1:set(a) -- not used
      feedbackNum2:set(b) -- not used
    else
      self.showAFirst = false
      colour2 = colourForNumber(a)
      colour1 = colourForNumber(b)
      sound2index = a-1
      sound1index = b-1
      feedbackNum2:set(a) -- not used
      feedbackNum1:set(b) -- not used
    end

    answer1 = a*b
    allButtons[ci].value = tostring(answer1)
    allButtons[ci].text:set(tostring(answer1))
    allButtons[ci].correct = true
    allButtons[ci].isDisabled = false

    ci = ci + 1; if ci > 3 then ci = 1 end

    self.valueA = tostring(a)
    self.valueB = tostring(b)
    self.textA:set(self.valueA)
    self.textB:set(self.valueB)

    -- in cases 12, 24, 36 show two questions
    if answer1 == 12 or answer1 == 24 or answer1 == 36 then
      show2Questions = true
    else
      show2Questions = false
    end

    -- wrong answers:
    repeat
      a = math.random(8) + 1
      b = math.random(8) + 1
      answer2 = a*b
    until not(answer2 == answer1)
    allButtons[ci].value = tostring(answer2)
    allButtons[ci].text:set(tostring(answer2))
    allButtons[ci].correct = false
    allButtons[ci].isDisabled = false

    ci = ci + 1; if ci > 3 then ci = 1 end

    repeat
      a = math.random(8) + 1
      b = math.random(8) + 1
      answer3 = a*b
    until not(answer3 == answer1) and not(answer3 == answer2)
    allButtons[ci].value = tostring(answer3)
    allButtons[ci].text:set(tostring(answer3))
    allButtons[ci].correct = false
    allButtons[ci].isDisabled = false
  else -- not the main question
    if show2Questions then
      self.showAFirst = true
      if (allQuestions[1].valueA == "4" and allQuestions[1].valueB == "6") or
         (allQuestions[1].valueA == "6" and allQuestions[1].valueB == "4") then
        self.valueA = tostring(3)
        self.valueB = tostring(8)
        self.textA:set(self.valueA)
        self.textB:set(self.valueB)
        colour3 = colourForNumber(3)
        colour4 = colourForNumber(8)
        self.colourA = colourForNumber(3)
        self.colourB = colourForNumber(8)
        sound3index = 2
        sound4index = 7
      elseif (allQuestions[1].valueA == "3" and allQuestions[1].valueB == "8") or
             (allQuestions[1].valueA == "8" and allQuestions[1].valueB == "3") then
        self.valueA = tostring(4)
        self.valueB = tostring(6)
        self.textA:set(self.valueA)
        self.textB:set(self.valueB)
        colour3 = colourForNumber(4)
        colour4 = colourForNumber(6)
        self.colourA = colourForNumber(4)
        self.colourB = colourForNumber(6)
        sound3index = 3
        sound4index = 5
      elseif (allQuestions[1].valueA == "2" and allQuestions[1].valueB == "6") or
             (allQuestions[1].valueA == "6" and allQuestions[1].valueB == "2") then
        self.valueA = tostring(3)
        self.valueB = tostring(4)
        self.textA:set(self.valueA)
        self.textB:set(self.valueB)
        colour3 = colourForNumber(3)
        colour4 = colourForNumber(4)
        self.colourA = colourForNumber(3)
        self.colourB = colourForNumber(4)
        sound3index = 2
        sound4index = 3
      elseif (allQuestions[1].valueA == "3" and allQuestions[1].valueB == "4") or
             (allQuestions[1].valueA == "4" and allQuestions[1].valueB == "3") then
        self.valueA = tostring(2)
        self.valueB = tostring(6)
        self.textA:set(self.valueA)
        self.textB:set(self.valueB)
        colour3 = colourForNumber(2)
        colour4 = colourForNumber(6)
        self.colourA = colourForNumber(2)
        self.colourB = colourForNumber(6)
        sound3index = 1
        sound4index = 5
      elseif (allQuestions[1].valueA == "4" and allQuestions[1].valueB == "9") or
             (allQuestions[1].valueA == "9" and allQuestions[1].valueB == "4") then
        self.valueA = tostring(6)
        self.valueB = tostring(6)
        self.textA:set(self.valueA)
        self.textB:set(self.valueB)
        colour3 = colourForNumber(6)
        colour4 = colourForNumber(6)
        self.colourA = colourForNumber(6)
        self.colourB = colourForNumber(6)
        sound3index = 5
        sound4index = 5
      elseif allQuestions[1].valueA == "6" and allQuestions[1].valueB == "6" then
        self.valueA = tostring(4)
        self.valueB = tostring(9)
        self.textA:set(self.valueA)
        self.textB:set(self.valueB)
        colour3 = colourForNumber(4)
        colour4 = colourForNumber(9)
        self.colourA = colourForNumber(4)
        self.colourB = colourForNumber(9)
        sound3index = 3
        sound4index = 8
      end
    end

  end
end

function colourForNumber(n)
  if n == 2 then return {255,226,0,200} -- kelt
  elseif n == 3 then return {199,44,58,200} -- pun
  elseif n == 4 then return {61,93,154,200} -- sin
  elseif n == 5 then return {0,145,106,200} -- vih
  elseif n == 6 then return {136,122,183,200} -- viol
  elseif n == 7 then return {245,131,77,200} -- orans
  elseif n == 8 then return {253,114,251,200} -- pinkki
  elseif n == 9 then return {170,66,37,200} -- ruskea
  end
end
