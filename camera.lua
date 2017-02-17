local Camera = Class:extend('Camera')

local DEFAULT = {
  x = 0, y = 0,
  scale = 1.0,
  width = (love and love.graphics.getWidth()) or 100,
  height = (love and love.graphics.getHeight()) or 100,
  scroll_width = 1000,
  scroll_height = 1000
}

function Camera:init(opts)
  for k, v in pairs(DEFAULT) do
    self[k] = opts[k] or DEFAULT[k]
  end

  self:setScale(self.scale)
  self:_updateViewportLimit()
end

function Camera:resizeViewport(width, height)
  self.width = width
  self.height = height
  self:_updateViewportLimit()
end

function Camera:resizeScroll(width, height)
  self.scroll_width = width
  self.scroll_height = height
  self:_updateViewportLimit()
end

function Camera:move(x, y)
  self.x = math.max(math.min(x - self.width / 2, self.max_x), 0)
  self.y = math.max(math.min(y - self.height / 2, self.max_y), 0)
end

function Camera:setScale(scale)
  self.scale = scale
  self.scale_width = math.ceil(self.width / self.scale)
  self.scale_height = math.ceil(self.height / self.scale)
end

function Camera:update(dt)

end

function Camera:attachWith(fn)
  love.graphics.push()
  love.graphics.scale(self.scale)
  love.graphics.translate(-self.x, -self.y)
  fn(self.x, self.y, self.scale_width, self.scale_height)
  love.graphics.pop()
end

function Camera:getViewportArea()
  return self.x, self.y, self.scale_width, self.scale_height
end

function Camera:_updateViewportLimit()
  self.max_x = self.scroll_width - self.width
  self.max_y = self.scroll_height - self.height
end

return Camera

