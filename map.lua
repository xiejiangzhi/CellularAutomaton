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
  self:setRule('23', '3', 2)

  self.time = 0
  self.last_updated_at = 0
  self.update_cycle = 0.1
  self.suspended = false
end

function Map:update(dt)
  if not self.suspended then self.time = self.time + dt end

  while self.time - self.last_updated_at >= self.update_cycle do
    self.last_updated_at = self.last_updated_at + self.update_cycle
    self:update_data()
  end
end

function Map:setRule(survival_rule, birth_rule, generations)
  self.survival_rule = survival_rule
  self.birth_rule = birth_rule
  self.generations = math.max(generations, 2)
end

function Map:set(x, y, val)
  if x < 1 or x > self.w or y < 1 or y > self.h then return end
  self.data[x][y] = val
end

function Map:get(x, y)
  return self.data[x][y]
end

function Map:update_data()
  local data = self.data
  self:reset()

  for j = 1, self.h do
    for i = 1, self.w do
      local total = 0
      for index, point in ipairs(SCAN_POINTS) do
        local x = (self.w + i - 1 + point[1]) % self.w + 1
        local y = (self.h + j - 1 + point[2]) % self.h + 1
        if data[x][y] and data[x][y] == 1 then total = total + 1 end
      end

      local str_total = tostring(total)
      local is_survival = string.find(self.survival_rule, str_total)
      local is_birth = string.find(self.birth_rule, str_total)

      if data[i][j] and data[i][j] > 0 then
        if is_survival then
          self.data[i][j] = data[i][j]
        else
          local v = (data[i][j] + 1) % self.generations
          if v > 0 then self.data[i][j] = v end
        end
      elseif is_birth then
        self.data[i][j] = 1
      end
    end
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
  self.data = {}
  for i = 1, self.w do self.data[i] = {} end
end

function Map:random(rate)
  rate = rate or 0.2

  for y = 1, self.h do
    for x = 1, self.w do
      if math.random() < rate then self.data[x][y] = 1 end
    end
  end
end

return Map

