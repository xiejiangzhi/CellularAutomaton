--
-- classic
--
-- Copyright (c) 2014, rxi
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
--


local Object = {}
Object.__index = Object
Object._class_name = 'Object'


function Object:extend(name)
  local cls = {}
  for k, v in pairs(self) do
    if k:find("__") == 1 then cls[k] = v end
  end
  cls._class_name = name or self._class_name
  cls._super = self
  cls._next_id = 1
  cls.__index = cls
  setmetatable(cls, self)

  cls.new = function(...)
    local obj = setmetatable({}, cls)
    obj._id = cls._next_id
    cls._next_id = cls._next_id + 1
    obj:init(...)
    return obj
  end

  return cls
end

function Object:include(...)
  for _, cls in pairs({...}) do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == "function" then
        self[k] = v
      end
    end
  end
end


function Object:init()
end

function Object:super_call(name, ...)
  getmetatable(self)._super[name](self, ...)
end

function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T or mt._class_name == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end

function Object:__tostring()
  if self._id then
    return '<' .. self._class_name .. ' ' .. self._id .. '>'
  else
    return self._class_name
  end
end

setmetatable(Object, {__tostring = Object.__tostring})

return Object

