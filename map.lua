local Map = Class:extend('Map')

local SCAN_POINTS = {
  {-1, -1}, {0, -1}, {1, -1},
  {-1, 0}, {1, 0},
  {-1, 1}, {0, 1}, {1, 1}
}


function Map:init(w, h)
  self.w = w
  self.h = h

  self.data = {}
  self:reset()
end

function Map:set(x, y, val)
  if x < 1 or x > self.w or y < 1 or y > self.h then return end
  self.data[x][y] = val
end

function Map:get(x, y)
  return self.data[x][y]
end

function Map:update()
  local todo_list = {}

  for j = 1, self.h do
    for i = 1, self.w do
      local total = 0
      for index, point in ipairs(SCAN_POINTS) do
        local x = (self.w + i - 1 + point[1]) % self.w + 1
        local y = (self.h + j - 1 + point[2]) % self.h + 1
        if self.data[x][y] then total = total + 1 end
        if total > 3 then break end
      end

      if self.data[i][j] then
        if total < 2 or total > 3 then table.insert(todo_list, {i, j, false}) end
      elseif total == 3 then
        table.insert(todo_list, {i, j, true})
      end
    end
  end

  for i, d in ipairs(todo_list) do
    self.data[d[1]][d[2]] = d[3]
  end
end

function Map:debug()
  for j = 1, self.h do
    s = ''
    for i = 1, self.w do
      if self.data[i][j] then
        s = s .. ' 1 '
      else
        s = s .. ' 0 '
      end
    end
    print(s)
  end
  print('----------------')
end

function Map:eachRect(l, t, w, h, fn)
  local sx = math.max(math.min(l + 1, self.w), 1)
  local ex = math.max(math.min(l + w, self.w), 1)
  local sy = math.max(math.min(t + 1, self.h), 1)
  local ey = math.max(math.min(t + h, self.h), 1)

  for i = sx, ex do
    for j = sy, ey do
      fn(i, j, self.data[i][j])
    end
  end
end

function Map:reset()
  for i = 1, self.w do self.data[i] = {} end
end

function Map:random(rate)
  rate = rate or 0.3

  for y = 1, self.h do
    for x = 1, self.w do
      if math.random() < rate then map:set(x, y, true) end
    end
  end
end

return Map

