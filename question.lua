Question = {}

function Question:new(params)
  o = {}
  o.x = params.x
  o.y = params.y
  o.height = params.height
  o.width = params.width
  o.value = params.value

  o.initiated = false

  local font = love.graphics.newFont("graphics/Krungthep.ttf", 56)
  o.text = love.graphics.newText(font, o.value)

  setmetatable(o, self)
  self.__index = self
  return o
end

function Question:draw()

  -- Question text
  love.graphics.setColor(50, 50, 50)
  love.graphics.draw(self.text, self.x, self.y)

end

function Question:update() -- called once a tick (for some reason)
  if not(self.initiated) then
    self.initiated = true
    self:newQuestion(self)
  end
end

function Question:newQuestion()
  local a, b, answer1, answer2, answer3
  local ci = math.random(3) -- how manieth question is right
  a = math.random(8) + 1
  b = math.random(8) + 1

  if a <= b then -- always lower number first for colour and sound
    colour1 = colourForNumber(a)
    colour2 = colourForNumber(b)
    sound1index = a-1
    sound2index = b-1
    feedbackNum1:set(a)
    feedbackNum2:set(b)
  else
    colour2 = colourForNumber(a)
    colour1 = colourForNumber(b)
    sound2index = a-1
    sound1index = b-1
    feedbackNum2:set(a)
    feedbackNum1:set(b)
  end

  answer1 = a*b
  allButtons[ci].value = tostring(answer1)
  allButtons[ci].text:set(tostring(answer1))
  allButtons[ci].correct = true
  allButtons[ci].isDisabled = false

  ci = ci + 1; if ci > 3 then ci = 1 end

  self.value = tostring(a) .. " · " .. tostring(b) .. " = "
  self.text:set(self.value)

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
