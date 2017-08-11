Button = {}

function Button:new(params)
  o = {}
  o.x = params.x
  o.y = params.y
  o.height = params.height
  o.width = params.width
  o.value = params.value -- number as a string - convert when comparing
  o.correct = false
  o.isDisabled = false

  local font = love.graphics.newFont("graphics/Krungthep.ttf", 56)
  o.text = love.graphics.newText(font, o.value)

  setmetatable(o, self)
  self.__index = self
  return o
end

function Button:draw()
  -- frame
  love.graphics.setColor(0, 0, 0)
  love.graphics.setLineWidth(5)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 5, 5)

  -- button background
  love.graphics.setColor(150, 150, 150)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 5, 5)

  -- button text
  if not(self.isDisabled) then
    love.graphics.setColor(50, 50, 50)
  else
    love.graphics.setColor(120, 120, 120)
  end
  love.graphics.draw(self.text, self.x + self.width*1/4, self.y + self.height*1/8)

end
