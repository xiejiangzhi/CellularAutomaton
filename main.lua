Class = require 'classic'
local Map = require 'map'
local Camera = require 'camera'

map = nil
camera = nil

time = 0
suspended = false
last_update = -1
update_cycle = 0.3

mouse_down_at = 0

min_scale = 1

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
end

function love.update(dt)
  if not suspended then time = time + dt end

  if suspended then
    local tile_val = nil

    if love.mouse.isDown(1) then
      tile_val = true
    elseif love.mouse.isDown(2) then
      tile_val = false
    end

    local mx, my = love.mouse.getPosition()
    mx = camera.x + math.ceil(mx / camera.width * map.w)
    my = camera.y + math.ceil(my / camera.height * map.h)
    if tile_val ~= nil then map:set(mx, my, tile_val) end
  else
    if love.mouse.isDown(1) and time - mouse_down_at > 0.1 then
      mouse_down_at = time
      place_cellulars(3, 0.3)
    end
  end

  while time - last_update >= update_cycle do
    last_update = last_update + update_cycle
    map:update()
  end
end

function love.draw()
  love.graphics.setBackgroundColor(255, 255, 255, 255)
  love.graphics.setColor(0, 0, 0)

  camera:attachWith(function(l, t, w, h)
    local points = {}

    map:eachRect(l, t, w, h, function(x, y, val)
      if val == true then
        love.graphics.rectangle('fill', (x - 1) * 10, (y - 1) * 10, 10, 10)
      end
    end)
  end)

  love.graphics.setColor(20, 80, 255, 255)
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10)
  love.graphics.print('cycle:' .. update_cycle .. ' press "up"/"down" update', 10, 30)
  love.graphics.print('lift-click place cell, right-click clear cell', 10, 50)
  love.graphics.print('"c" clear all cell', 10, 70)
  love.graphics.print('"r" clear all and place random', 10, 90)
  love.graphics.print('suspended:' .. tostring(suspended) .. ' , "space" stop/recover time', 10, 110)
end

function love.keypressed(key, code)
  if key == 'up' then
    update_cycle = update_cycle + 0.1
  elseif key == 'down' then
    update_cycle = math.max(0.1, update_cycle - 0.1)
  elseif key == 'r' then
    map:random()
  elseif key == 'c' then
    map:reset()
  elseif key == 'space' then
    suspended = not suspended
  end
end

function place_cellulars(radius, rate)
  radius = radius or 6
  rate = rate or 0.3

  local mx, my = love.mouse.getPosition()
  mx = camera.x + math.ceil(mx / camera.width * map.w)
  my = camera.y + math.ceil(my / camera.height * map.h)

  map:eachRect(mx - radius, my - radius, radius * 2, radius * 2, function(x, y, val)
    if math.random() < rate then
      map:set(x, y, true)
    end
  end)
end

