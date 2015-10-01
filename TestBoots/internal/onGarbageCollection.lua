--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local function onGarbageCollection(xTable, xCallOnGC)
  if _VERSION >= "Lua 5.2" then
    setmetatable(xTable, {__gc = xCallOnGC})
  else
    xTable.sentinel = newproxy(true)
    getmetatable(xTable.sentinel).__gc = xCallOnGC
  end
end

return onGarbageCollection