Class = require 'classic'
local Map = require 'map'
local Camera = require 'camera'

map = nil
camera = nil

mouse_down_at = 0

min_scale = 1
colors = { }

function love.load()
  math.randomseed(os.time())

  map = Map.new(240, 180)
  camera = Camera.new{
    width = love.graphics.getWidth(), height = love.graphics.getHeight(),
    scroll_width = map.w, scroll_height = map.h,
  }
  min_scale = camera.width / map.w / 10
  camera:setScale(min_scale)

  map:random(0.3)
  map:setRule('345', '2', 4)
end

function love.update(dt)
  if map.suspended then
    local tile_val = nil

    if love.mouse.isDown(1) then
      tile_val = 1
    elseif love.mouse.isDown(2) then
      tile_val = 0
    end

    local mx, my = love.mouse.getPosition()
    mx = camera.x + math.ceil(mx / camera.width * map.w)
    my = camera.y + math.ceil(my / camera.height * map.h)
    if tile_val ~= nil then map:set(mx, my, tile_val) end
  else
    if love.mouse.isDown(1) then place_cellulars(3, 0.1) end
  end

  map:update(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(255, 255, 255, 255)
  draw_map()

  love.graphics.setColor(20, 80, 255, 255)
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10)
  love.graphics.print('cycle:' .. map.update_cycle .. ' press "up"/"down" update', 10, 30)
  love.graphics.print('lift-click place cell, right-click clear cell', 10, 50)
  love.graphics.print('"c" clear all cell', 10, 70)
  love.graphics.print('"r" clear all and place random', 10, 90)
  love.graphics.print('suspended:' .. tostring(map.suspended) .. ' , "space" stop/recover time', 10, 110)
end

function love.keypressed(key, code)
  if key == 'up' then
    map.update_cycle = map.update_cycle + 0.1
  elseif key == 'down' then
    map.update_cycle = math.max(0.1, map.update_cycle - 0.1)
  elseif key == 'r' then
    map:random()
  elseif key == 'c' then
    map:reset()
  elseif key == 'space' then
    map.suspended = not map.suspended
  end
end

function draw_map()
  local mc = 10
  local rc = 180
  for i = 1, map.generations do
    if not colors[i] then
      colors[i] = {mc + math.random(rc), mc + math.random(rc), mc + math.random(rc)}
    end
  end

  camera:attachWith(function(l, t, w, h)
    map:eachRect(l, t, w, h, function(x, y, val)
      if not val or val == 0 then return end

      love.graphics.setColor(unpack(colors[val]))
      love.graphics.rectangle('fill', (x - 1) * 10, (y - 1) * 10, 10, 10)
    end)
  end)
end

function place_cellulars(radius, rate)
  radius = radius or 6
  rate = rate or 0.3

  local mx, my = love.mouse.getPosition()
  mx = camera.x + math.ceil(mx / camera.width * map.w)
  my = camera.y + math.ceil(my / camera.height * map.h)

  map:eachRect(mx - radius, my - radius, radius * 2, radius * 2, function(x, y, val)
    if math.random() < rate then
      map:set(x, y, 1)
    end
  end)
end

