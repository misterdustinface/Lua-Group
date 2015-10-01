--  Copyright (C) 2015  Dustin Shaffer
--  Licensed under the GNU GENERAL PUBLIC LICENSE, Version 2

local function timeExecution__sec(xFunction, ...)
  local clock = os.clock; 
  local startTime = clock();
  xFunction(...)
  local dt = clock() - startTime
  return dt
end

return timeExecution__sec