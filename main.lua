
local Player = require('player')
local Cursor = require('cursor')
local Asteroid = require('asteroid')

function love.load(arg)
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    player = Player(300, 200)
    cursor = Cursor()
    player.cursor = cursor;
    a1 = Asteroid(200, 300)
end

function love.draw()
    player:draw()
    a1:draw()
    cursor:draw()
end

function love.update(dt)
  cursor:update(dt)
  player:update(dt)
  a1:update(dt, 11)

  if love.keyboard.isDown('escape') then
    love.event.quit()
    end
end

