Audio = {}

function Audio:new(params)
  o = {}
  o.initiated = false
  o.Note = {}
  o.Note[1] = {}
  o.Note[2] = {}

  o.Note[1][1] = love.audio.newSource("sounds/c.wav", "static")
  o.Note[1][2] = love.audio.newSource("sounds/d.wav", "static")
  o.Note[1][3] = love.audio.newSource("sounds/e.wav", "static")
  o.Note[1][4] = love.audio.newSource("sounds/f.wav", "static")
  o.Note[1][5] = love.audio.newSource("sounds/g.wav", "static")
  o.Note[1][6] = love.audio.newSource("sounds/a.wav", "static")
  o.Note[1][7] = love.audio.newSource("sounds/h.wav", "static")
  o.Note[1][8] = love.audio.newSource("sounds/c2.wav", "static")

  o.Note[2][1] = love.audio.newSource("sounds/c.wav", "static")
  o.Note[2][2] = love.audio.newSource("sounds/d.wav", "static")
  o.Note[2][3] = love.audio.newSource("sounds/e.wav", "static")
  o.Note[2][4] = love.audio.newSource("sounds/f.wav", "static")
  o.Note[2][5] = love.audio.newSource("sounds/g.wav", "static")
  o.Note[2][6] = love.audio.newSource("sounds/a.wav", "static")
  o.Note[2][7] = love.audio.newSource("sounds/h.wav", "static")
  o.Note[2][8] = love.audio.newSource("sounds/c2.wav", "static")

  setmetatable(o, self)
  self.__index = self
  return o
end
