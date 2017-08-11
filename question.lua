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
  colour1 = colourForNumber(a)
  colour2 = colourForNumber(b)
  answer1 = a*b
  allButtons[ci].value = tostring(answer1)
  allButtons[ci].text:set(tostring(answer1))
  allButtons[ci].correct = true
  allButtons[ci].isDisabled = false

  ci = ci + 1; if ci > 3 then ci = 1 end

  self.value = tostring(a) .. " * " .. tostring(b) .. " = "
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
  if n == 2 then return {100,200,255,255} -- kelt
  elseif n == 3 then return {255,100,100,255} -- pun
  elseif n == 4 then return {100,100,255,255} -- sin
  elseif n == 5 then return {100,255,100,255} -- vih
  elseif n == 6 then return {255,100,255,255} -- viol
  elseif n == 7 then return {255,200,100,255} -- orans
  elseif n == 8 then return {255,100,200,255} -- pinkki
  elseif n == 9 then return {200,150,200,255} -- ruskea
  end
end
